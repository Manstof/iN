//
//  AppDelegate.swift
//  iN
//
//  Created by Mark Manstof on 3/18/16.
//  Copyright © 2016 Mark Manstof. All rights reserved.
//

import UIKit
import Bolts
import Parse
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var locationManager: CLLocationManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Make the navigation bar pretty
        let iNBlue = UIColor(red: 107.0/255.0, green: 196.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        UINavigationBar.appearance().barTintColor = iNBlue
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        if let barFont = UIFont(name: "Avenir", size: 24.0) {
        
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:barFont]
        
        }
        
        //Ask user if we can use their location
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        //Parse on Heroku
        let parseConfiguration = ParseClientConfiguration( block: {   (ParseMutableClientConfiguration) -> Void in
            
            ParseMutableClientConfiguration.applicationId = "XR8fncEaMFY9pzeZ7Cb7YF6kMkjrRV5rAMnMxJ31"
            
            ParseMutableClientConfiguration.clientKey = "9WN6gCM66Az9N3tYjHfsqE0rI3Hs7ctgBCcp9AHl"
            
            ParseMutableClientConfiguration.server = "http://in.herokuapp.com/parse"
        
        })
        
        /*
        //Old Parse
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios/guide#local-datastore
        Parse.enableLocalDatastore()
        // Initialize Parse.
        Parse.setApplicationId("XR8fncEaMFY9pzeZ7Cb7YF6kMkjrRV5rAMnMxJ31", clientKey: "3RQ1eHwSs8tiCh1IqIt0aoWHpNzJJs8Htz4fkiFV")
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        */
        
        return true
    
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

