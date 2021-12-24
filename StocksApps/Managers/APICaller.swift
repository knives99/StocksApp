//
//  APICaller.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/16.
//

import Foundation
import CoreText

final class APICaller {
    
    private struct Constants{
        static let apiKey = "c6tg0diad3ieolro94vg"
        static let sandboxApiKey = "sandbox_c6tg0diad3ieolro9500"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day:TimeInterval = 60*60*24
    }
    
    static let shared = APICaller()
    
    private init (){}
    
    //MARK: - Public
    public func search(query:String,completion:@escaping(Result<SearchResponse,Error>)-> Void){
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let url = url(for: .search,queryParams: ["q":safeQuery]) else {return}
        request(url: url, expecting: SearchResponse.self, completion: completion)
  
    }
    
    public func news(for type:NewsViewController.`Type`,completion: @escaping (Result<[NewsStory],Error>)-> Void){
        switch type{
        case .topStories:
            let url = url(for: .topStories, queryParams: ["category":"general"])
            request(url: url, expecting: [NewsStory].self, completion: completion)
            
        case.compan(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day*7))
            let url = url(for: .companyNews, queryParams: ["symbol":symbol,
                                                           "from":DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                                                           "to":DateFormatter.newsDateFormatter.string(from: today)])
            request(url: url, expecting: [NewsStory].self, completion: completion)
            
        }
        
    }
    public func marketData(for symbol:String,numberOfDays:TimeInterval = 7,completion:@escaping(Result<MarketDataResponse,Error>) -> Void){
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        let url = url(for: .marketData,
                         queryParams: [
                            "symbol":symbol,
                            "resolution":"1",
                            "from":"\(Int(prior.timeIntervalSince1970 ))",
                            "to":"\(Int(today.timeIntervalSince1970))"
                         ])
        request(url: url, expecting: MarketDataResponse.self, completion: completion)
        
    }
    
    //get stock info
    
    //search stocks
    
    //MARK: - Private
    
    
    private enum Endpoint: String{
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "/stock/candle"
    }
    
    private enum APIError : Error{
        case invaildURL
        case noDataReturned
        
    }
    
    private func url (for endpoint:Endpoint, queryParams:[String:String] = [:] ) -> URL?{
        
        var urlString = Constants.baseUrl + endpoint.rawValue
        var quertItems = [URLQueryItem]()
        //Add ant parameters
        for (key,value) in queryParams {
            quertItems.append(.init(name: key, value: value))
        }
        
        // Add token
        quertItems.append(.init(name: "token", value: Constants.apiKey))
        
        //Convert query to suffix  string
        let queryString = quertItems.map({"\($0.name)=\($0.value ?? "")"}).joined(separator: "&")
        
        urlString = urlString + "?" + queryString
        
        return URL(string: urlString)
    }
    
    
    private func request<T:Codable> (url:URL?,
                                     expecting:T.Type,
                                     completion:@escaping(Result<T,Error>) -> Void){
        guard let url = url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
               print("ERROR")
                return
            }
            guard error == nil  else {
                completion(.failure(APIError.invaildURL))
                return
            }
            
            do{
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}
