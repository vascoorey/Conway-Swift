//
//  AppDelegate.swift
//  Conway
//
//  Created by Vasco d'Orey on 04/06/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

import UIKit

extension Int {
  func times(task: () -> ()) {
    for i in 0..self {
      task()
    }
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    // Override point for customization after application launch.
    
    var game = Conway(rows: 40, columns: 40)
    game.flipStateAtPoint(9, column: 6)
    game.flipStateAtPoint(9, column: 7)
    game.flipStateAtPoint(7, column: 7)
    game.flipStateAtPoint(8, column: 9)
    game.flipStateAtPoint(9, column: 10)
    game.flipStateAtPoint(9, column: 11)
    game.flipStateAtPoint(9, column: 12)
    println(game.descriptionWithNeighborCounts())
    
    100.times {
      game.tick()
    }
    
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

