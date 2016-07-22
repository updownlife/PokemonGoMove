//
//  AppDelegate.swift
//  foo
//
//  Created by Jason Lee on 16/7/12.
//  Copyright © 2016年 ruby-china. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let app = UIApplication.sharedApplication()
    
    var backgroundTask: UIBackgroundTaskIdentifier!
    
    var audioPlayer: AVAudioPlayer!
    
    var audioEngine = AVAudioEngine()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        print("Enter background")
        
        self.backgroundTask = app.beginBackgroundTaskWithExpirationHandler() {
            self.app.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(AppDelegate.checkTime), userInfo: nil, repeats: true)
        
    }
    
    func checkTime() {
        
        print("Background time remaining: \(app.backgroundTimeRemaining)")
        
        if app.backgroundTimeRemaining < 20 {
            playSound()
        }
        
    }
    
    func playSound() {
        
        print("Play silent sound and reset remaining time")
        
        let soundFilePath = NSURL(string: NSBundle.mainBundle().pathForResource("silent", ofType: "mp3")!)!
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
        } catch _ {
        }
        
        self.audioPlayer = try? AVAudioPlayer(contentsOfURL: soundFilePath)
        
        self.audioEngine.reset()
        self.audioPlayer.play()
        
        self.app.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = app.beginBackgroundTaskWithExpirationHandler() {
            self.app.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("Enter foreground")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}