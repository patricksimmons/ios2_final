//
//  AppDelegate.swift
//  ios2_finalProject
//
//  Created by Xcode User on 2017-12-21.
//  Copyright © 2017 Xcode User. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var keyArray: NSArray?
    var someMutableArray: NSMutableArray?
    var audioPlayer: AVAudioPlayer?
    var audioPlayer2: AVAudioPlayer?
    var song: MPMediaItem?
    var song2: MPMediaItem?
    var volNum: Float?
    var volNum2: Float?
    var songBPM: Float?
    var songBPM2: Float?
    var mixBPM: Float?
    var trackIds: [Int]?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        keyArray =  ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"];
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

