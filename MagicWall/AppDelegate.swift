//
//  AppDelegate.swift
//  MagicWall
//
//  Created by user on 2020/11/16.
//

import Cocoa
import SpriteKit
import WebKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var window = BrowserWindow()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.isReleasedWhenClosed = false
        window.isDesktop = false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu()
        menu.addItem(.init(title: "Return to Window", action: #selector(returnToWindow), keyEquivalent: ""))
        return menu
    }

    @objc func returnToWindow() {
        window.isDesktop = false
    }
}

