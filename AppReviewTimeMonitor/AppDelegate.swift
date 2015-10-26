//
//  AppDelegate.swift
//  AppReviewTimeMonitor
//
//  Created by Alexander Kasimir on 26/10/15.
//  Copyright © 2015 Alexander Kasimir. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var counter = 0

    @IBOutlet weak var menu: NSMenu!

    @IBAction func refreshAction(sender: AnyObject) {
        refreshTimes()
    }

    @IBAction func quitAction(sender: AnyObject) {
    }

    @IBAction func gotoWebsiteAction(sender: AnyObject) {
    }
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let icon = AppReviewTimeMonitorStyleKit.imageOfStatusBarImage(dayLabel: "??")
        icon.template = true
        statusItem.image = icon
        statusItem.menu = menu
    }

    func refreshTimes() {
        counter++
        let icon = AppReviewTimeMonitorStyleKit.imageOfStatusBarImage(dayLabel: "\(counter)")
        icon.template = true
        statusItem.image = icon
    }

}

