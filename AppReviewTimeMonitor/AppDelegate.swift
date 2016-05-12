//
//  AppDelegate.swift
//  AppReviewTimeMonitor
//
//  Created by Alexander Kasimir on 26/10/15.
//  Copyright © 2015 Alexander Kasimir. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!

    @IBAction func refreshAction(sender: AnyObject) {
        refreshTimes()
    }

    @IBAction func quitAction(sender: AnyObject) {
        exit(0)
    }

    @IBOutlet weak var lastrefreshedItem: NSMenuItem!
    @IBOutlet weak var gotoWebsiteItem: NSMenuItem!

    @IBAction func gotoWebsiteAction(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://appreviewtimes.com/")!)
    }
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        showErrorIcon()
        refreshTimes()
        statusItem.menu = menu
        gotoWebsiteItem.image = AppReviewTimeMonitorStyleKit.imageOfOpenLink

        // start timer to update values every 30 min
        NSTimer.scheduledTimerWithTimeInterval(60*30, target:self, selector: #selector(AppDelegate.refreshTimes), userInfo: nil, repeats: true)
    }

    func refreshTimes() {
        Alamofire.request(.GET, "http://appreviewtimes.com/").responseData { response in

            if response.result.isSuccess {
                let result=String(NSString(data: response.result.value!, encoding: NSUTF8StringEncoding))
                let pattern = "data-target=\".review....\"><strong>... App Store</strong> (.*?) day"
                let days = self.extractData(result,regexp: pattern)

                let iosLabel:String
                let osxLabel:String

                if days.iosStore != -1 {
                    iosLabel = "\(days.iosStore)"
                    osxLabel = "\(days.osxStore)"
                } else {
                    iosLabel = "??"
                    osxLabel = "??"
                }

                self.updateIcons(iosLabel:"\(iosLabel)", osxLabel:"\(osxLabel)")
            } else {
                self.showErrorIcon()
            }
        }
    }

    func updateIcons(iosLabel iosLabel:String, osxLabel:String) {
        let icon = AppReviewTimeMonitorStyleKit.imageOfCombinedStatusBarImage(iosDayLabel: iosLabel, osxDayLabel: osxLabel)
        icon.template = true
        statusItem.image = icon

        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .MediumStyle

        lastrefreshedItem.title = "\(formatter.stringFromDate(NSDate()))"
    }

    func showErrorIcon() {
        let icon = AppReviewTimeMonitorStyleKit.imageOfCombinedStatusBarError
        icon.template = true
        statusItem.image = icon
    }


    func extractData(str:String, regexp:String) -> (iosStore:Int, osxStore:Int){
        var ret:[Int] = []
        do {
            let regexp = try RegExp(pattern:regexp, options: NSRegularExpressionOptions.AnchorsMatchLines)
            let matches = regexp!.allMatches(str)
            for match in matches {
                print(match)
                if let value = Int(match) {
                    ret.append(value)
                }
            }
        } catch {
            print(error)
        }

        if ret.count == 2 {
            return (iosStore:ret[0], osxStore:ret[1])
        } else {
            return (iosStore:-1, osxStore:-1)
        }
    }
 }
