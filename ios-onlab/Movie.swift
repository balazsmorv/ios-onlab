//
//  Movie.swift
//  onTV
//
//  Created by Morvay Balázs on 2020. 01. 27..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import Foundation
import UIKit // for the poster picture
import Combine

class Movie: Codable, Identifiable, ObservableObject {
    
    let title: String
    let year: String
    let rated: String
    let released: String // date would be better
    let runtime: String
    var genre: String
    let director: String
    let writers: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: String
    let IMDBRating: String
    let Metascore: String
    let IMDBNumberOfVotes: String
    let IMDBid: String
    let type: String
    let id = UUID()
    
    @Published var image: UIImage = #imageLiteral(resourceName: "posterNotFound")
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writers = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case IMDBRating = "imdbRating"
        case Metascore = "Metascore"
        case IMDBNumberOfVotes = "imdbVotes"
        case IMDBid = "imdbID"
        case type = "Type"
    }
    
    func getPosterImage(from urlString: String) {
        print("trying to get poster images")
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self.image = image
                    print("got image")
                }
            } else {
                print("no poster data")
            }
        } else {
            print("url not correct: \(urlString)")
        }
    }
}





class MovieList: ObservableObject {
    
    @Published var items = [Movie]()
    
    init(with titles: [String]) {
        for movie in titles {
            DispatchQueue.global(qos: .userInitiated).async {
                self.makeRequest(for: movie)
            }
        }
    }

    private func requestData(with imdbID: String) {
        let headers = [
            "x-rapidapi-host": "movie-database-imdb-alternative.p.rapidapi.com",
            "x-rapidapi-key": "936907b99fmshb8b8ce9f592618bp14616ajsnc7cb6f502808"
        ]

        let url = "https://movie-database-imdb-alternative.p.rapidapi.com/?i=" + imdbID + "&r=json"
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                if data != nil {
                    let movie = try! JSONDecoder().decode(Movie.self, from: data!)
                    movie.getPosterImage(from: movie.poster)
                    DispatchQueue.main.async {
                        self.items.append(movie)
                        self.items.sort {$0.IMDBRating > $1.IMDBRating}
                        print("items appended with \(movie.title)")
                    }
                    
                } else {
                    print("data is nil.")
                }
            }
        })
        
        dataTask.resume()

    }
    
    
    private func makeRequest(for title: String) {
        
        print("making request for title: \(title)")
        
        let headers = [
            "x-rapidapi-host": "imdb-internet-movie-database-unofficial.p.rapidapi.com",
            "x-rapidapi-key": "936907b99fmshb8b8ce9f592618bp14616ajsnc7cb6f502808"
        ]

        let original = "https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/" + title
        
        let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded!)
        
        let request = NSMutableURLRequest(url: url!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                if data != nil {
                    let idRequest = try! JSONDecoder().decode(IDInfo.self, from: data!)
                    DispatchQueue.global(qos: .userInitiated).async {
                        print("request data for \(title)")
                        self.requestData(with: idRequest.titles[0].id)
                    }
                }
            }
        })

        dataTask.resume()
    }
    
}
