//
//  PersistenceManager.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/16.
//

import Foundation
import UIKit

final class PersistenceManager{
    static let shared = PersistenceManager()
    
    private let userDefault:UserDefaults = .standard
    private struct Constants{
        static let onboardedKey = "hasOnboarded"
        static let watchListKey  = "watchlist"
    }
    private init (){}
    
    
    //MARK: - Public
    public var watchlist:[String]{
        if !hasOnBoarded{
            userDefault.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        //回傳 [AAPL,MSFT,SNAP,GOOG] 這樣的array
        return userDefault.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    public func addToWtachlist(){}
    
    public func removeFromWatchlist(){}
    
    //MARK: - private
    private var hasOnBoarded:Bool{
        return userDefault.bool(forKey: Constants.onboardedKey)
    }
    private func setUpDefaults(){
        let map :[String:String] = [
            "AAPL":"APPLE Inc",
            "MSFT":"Microsoft Corporatiob",
            "SNAP":"SNAP Inc",
            "GOOG":"Alphabet",
            "ANZN":"Amazon.com, Inc.",
            "WORK":"Slack Technologies",
            "FB":"Facebook Inc",
            "NVDA":"Nvidia Inc",
            "NKE":"Nike",
            "PINS":"Pinterest Inc."
        ]
        
        let Symbols = map.keys.map{$0}
        userDefault.set(Symbols, forKey: Constants.watchListKey)
        
        for(symbol,name) in map {
            userDefault.set(name, forKey: symbol)
        }
    }
}

