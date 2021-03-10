//
//  BrowserWindow.swift
//  MagicWall
//
//  Created by user on 2021/03/11.
//

import Cocoa
import WebKit

class BrowserWindow: NSWindow {
    let webview = WKWebView()
    let toolbar_persisted = NSToolbar()

    var isDesktop: Bool = false {
        didSet {
            switch isDesktop {
            case true:
                level = .init(Int(CGWindowLevelForKey(.desktopIconWindow)))
                styleMask = [.closable, .miniaturizable, .resizable, .fullSizeContentView]
                if let screen = screen ?? NSScreen.main {
                    setFrame(screen.frame, display: true, animate: true)
                }
            case false:
                level = .normal
                styleMask = [.closable, .miniaturizable, .resizable, .fullSizeContentView, .titled]
                toolbar = toolbar_persisted
                center()
                makeKeyAndOrderFront(nil)
            }
        }
    }
    
    init() {
        super.init(
            contentRect: .init(origin: .zero, size: .init(width: 640, height: 360)),
            styleMask: [.closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        toolbar_persisted.displayMode = .iconOnly
        toolbar_persisted.delegate = self
        webview.load(URLRequest(url: URL(string: "https://www.youtube.com/embed/pqiJ7krbEDM?vq=hd1080")!))
        bind(.title, to: webview, withKeyPath: "title", options: nil)
        contentView = webview
    }
}

extension NSToolbarItem.Identifier {
    static let changeURL = NSToolbarItem.Identifier(rawValue: "changeURL")
    static let showAsDesktop = NSToolbarItem.Identifier(rawValue: "showAsDesktop")
}

extension BrowserWindow: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .changeURL,
            .showAsDesktop,
        ]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarAllowedItemIdentifiers(toolbar)
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        print(itemIdentifier)
        switch itemIdentifier {
        case .changeURL:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.title = "URL"
            item.action = #selector(changeURL)
            if #available(OSX 11.0, *) {
                item.isNavigational = true
            }
            item.isBordered = true
            return item
        case .showAsDesktop:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.title = "Show as Desktop"
            item.action = #selector(showAsDesktop)
            item.isBordered = true
            return item
        default:
            return nil
        }
    }
    
    @objc func showAsDesktop() {
        isDesktop = true
    }
    
    @objc func changeURL() {
        let alert = NSAlert()
        alert.messageText = "Change URL"
        let field = NSTextField(string: webview.url?.absoluteString ?? "https://example.com")
        field.placeholderString = "https://example.com"
        alert.accessoryView = field
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: self) { [weak self] res in
            guard res == .alertFirstButtonReturn else {
                return
            }
            print(field.stringValue)
            guard let url = URL(string: field.stringValue) else {
                return
            }
            print(url)
            self?.webview.load(.init(url: url))
        }
    }
}
