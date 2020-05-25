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

//Egy TV-ben futó műsorról tárol infókat
class Movie: Codable, Identifiable, ObservableObject {
    
    let title: String
    var channel = "TinaTV"
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
    
    init() {
        title = "Tina feneke"
        channel = "TinaTV"
        year = "Year"
        rated = "Rated"
        released = "Released"
        runtime = "Runtime"
        genre = "Genre"
        director = "Director"
        writers = "Writer"
        actors = "Actors"
        plot = "Plot"
        language = "Language"
        country = "Country"
        awards = "Awards"
        poster = "Poster"
        IMDBRating = "100"
        Metascore = "Metascore"
        IMDBNumberOfVotes = "imdbVotes"
        IMDBid = "imdbID"
        type = "Type"
    }
    
    // JSON dekódoláshoz
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
    
    // posztert tölti le paraméterben kapott url alapján
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


// Fenti Movie osztályokat összegyűjti tömbbe, kezeli az imdb lekérdezéseket hozzájuk
class MovieList: ObservableObject {
    
    // Az összes kiírandó TV műsor
    @Published var items = [Movie]()
    // Az összes TV csatorna amire rá lehet szűrni
    @Published var availableChannels = [Channel]()
    // TVGuide kezeli a műsorinformációk letöltését, és átalakítását
    let tvGuide = TVGuide()
    
    init() {
        self.fillUp()
    }
    
    func fillUp() {
        tvGuide.fillTVGuide(requested_by: self)
    }
    
    func fillUpList() {
        for movie in tvGuide.getCurrentTitles() {
            DispatchQueue.global(qos: .userInitiated).async {
                self.makeRequest(for: movie)
            }
        }
    }

    // 2. API: kapott IMDB ID-ra keres rá IMDB-n, és a visszakapott adatokból Movie példányt készít, eltárolja őket az items tömbben
    private func requestData(with imdbID: String, for program: TVProgramme) {
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
                    if let movie = try? JSONDecoder().decode(Movie.self, from: data!) {
                        movie.getPosterImage(from: movie.poster)
                        movie.channel = program.channel
                        DispatchQueue.main.async {
                            self.items.append(movie)
                            self.items.sort {$0.IMDBRating > $1.IMDBRating}
                        }
                    } else {
                        print("Movie.requestData(with imdbID: \(imdbID)): couldnt decode JSON data to Movie instance")
                    }
                    
                } else {
                    print("Movie.requestData(with imdbID: \(imdbID)): Couldnt download data from the given url. Could indicate API problem.")
                }
            }
        })
        
        dataTask.resume()

    }
    
    // Az első API-t használja: Egy műsor címére történő keresés IMDB találatait kapja vissza, ebből nekünk az IMDB ID a fontos, azt adjuk a második API-nak
    private func makeRequest(for program: TVProgramme) {
                
        print("making request for title: \(program.title)")
        
        let headers = [
            "x-rapidapi-host": "imdb-internet-movie-database-unofficial.p.rapidapi.com",
            "x-rapidapi-key": "936907b99fmshb8b8ce9f592618bp14616ajsnc7cb6f502808"
        ]

        let original = "https://imdb-internet-movie-database-unofficial.p.rapidapi.com/search/" + program.title
        
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
                    if let idRequest = try? JSONDecoder().decode(IDInfo.self, from: data!) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            print("request data for \(program.title)")
                            if(idRequest.titles.count > 0) {
                                self.requestData(with: idRequest.titles[0].id, for: program)
                            } else {
                                print("no title: \(program.title) found on imdb ")
                            }
                        }
                    }
                }
            }
        })

        dataTask.resume()
    }
    
}
