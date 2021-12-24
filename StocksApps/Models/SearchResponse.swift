//
//  SearchResponse.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/17.
//

import Foundation

struct SearchResponse :Codable{
    
    let count :Int
    let result:[SearchResult]
}

struct SearchResult: Codable{
    
    let description:String
    let displaySymbol: String
    let symbol:String
    let type :String
}
