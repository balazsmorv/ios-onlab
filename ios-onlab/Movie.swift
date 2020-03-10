//
//  Movie.swift
//  onTV
//
//  Created by Morvay Balázs on 2020. 01. 27..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import Foundation

struct Movie: Codable, Identifiable {
    
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
}
