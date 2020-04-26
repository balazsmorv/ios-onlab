//
//  Request.swift
//  onTV
//
//  Created by Morvay Balázs on 2020. 01. 27..
//  Copyright © 2020. BME AUT. All rights reserved.
//

//import Foundation
//
//class Request {
//    
//    static func makeRequest(with imdbID: String) {
//        let headers = [
//            "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
//            "x-rapidapi-key": "936907b99fmshb8b8ce9f592618bp14616ajsnc7cb6f502808"
//        ]
//
//        let url = "https://movie-database-imdb-alternative.p.rapidapi.com/?i=" + imdbID + "&r=json"
//        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
//            cachePolicy: .useProtocolCachePolicy,
//            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        let session = URLSession.shared
//        
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error!)
//            } else {
//                if data != nil {
//                    
//                    let movie = try! JSONDecoder().decode(MovieInfo.self, from: data!)
//                    
//                } else {
//                    print("data is nil.")
//                }
//            }
//        })
//        
//        dataTask.resume()
//
//    }
//    
//    
//    static func getID(for title: String) {
//        
//        let headers = [
//            "x-rapidapi-host": "imdb-internet-movie-database-unofficial.p.rapidapi.com",
//            "x-rapidapi-key": "936907b99fmshb8b8ce9f592618bp14616ajsnc7cb6f502808"
//        ]
//
//        let original = "https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/" + title
//        
//        let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
//        let url = URL(string: encoded!)
//        
//        let request = NSMutableURLRequest(url: url!,
//                                          cachePolicy: .useProtocolCachePolicy,
//                                          timeoutInterval: 10.0)
//
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//        
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error!)
//            } else {
//                if data != nil {
//                    let idRequest = try! JSONDecoder().decode(IDInfo.self, from: data!)
//                    Request.makeRequest(with: idRequest.titles[0].id)
//                }
//            }
//        })
//
//        
//        dataTask.resume()
//            
//    }
//    
//    static func getMovie(for title: String) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let idData = Request.getID(for: title)
//            let idRequest = try! JSONDecoder().decode(IDInfo.self, from: idData!)
//            let data = Request.makeRequest(with: idRequest.titles[0].id)
//            let movie = try! JSONDecoder().decode(MovieInfo.self, from: data!)
//            DispatchQueue.main.async {
//                
//            }
//        }
//    }
//    
//    
//    
//}
