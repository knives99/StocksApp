//
//  AppDelegate.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        debug()
        APICaller.shared.search(query: "ff") { result in
            switch result{
            case.success(let response):
//                print(response.result)
                break
            case.failure(let error):
                print(error)
            }
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

    
    private func debug(){
        APICaller.shared.marketData(for: "AAPL", numberOfDays: 1) { result in
            print(result)
        }
    }

}

