//
//  MarketDataResponse.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/24.
//

import Foundation


struct MarketDataResponse :Codable{
    let open : [Double]
    let close : [Double]
    let high : [Double]
    let low: [Double]
    let status :String
    let timestamps: [TimeInterval]
    
    enum CodingKeys: String ,CodingKey{
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case status = "s"
        case timestamps = "t"
    }
}
