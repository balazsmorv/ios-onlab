//
//  ListView.swift
//  tvDB swiftUI
//
//  Created by Morvay Balázs on 2020. 03. 03..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

let titles = ["Mátrix", "Mentalista", "Agymenok", "Sonic, a sündisznó"]

struct ListView: View {
    
    
    let filmList = getFilmList(for: titles).sorted{$0.IMDBRating > $1.IMDBRating}
//    let filmList = [Request.getMovie(for: "Mátrix"),
//                    Request.getMovie(for: "Mentalista"),
//                    Request.getMovie(for: "Agymenok"),
//                    Request.getMovie(for: "Sonic, a sündisznó"),
//                    Request.getMovie(for: "Baratok kozt"),
//                    Request.getMovie(for: "Noi szervek"),
//                    Request.getMovie(for: "Avatár"),
//                    Request.getMovie(for: "CSI: Miami helyszínelok"),
//                    Request.getMovie(for: "Baywatch"),
//                    Request.getMovie(for: "Scooby doo"),
//                    Request.getMovie(for: "Forgács"),
//                    Request.getMovie(for: "Lucifer"),
//                    Request.getMovie(for: "Bad boys for life")].sorted {$0.IMDBRating > $1.IMDBRating}
    
    
    
    var body: some View {
        NavigationView {
            List(filmList) { film in
                NavigationLink(destination: MovieView(movie: film)) {
                    MovieListRowView(movie: film)
                }
            }.navigationBarTitle("What to watch")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}


func getFilmList(for titles: [String]) -> [Movie] {
    var filmList = [Movie]();
    for title in titles {
        DispatchQueue.global(qos: .background).async {
            let newMovie = Request.getMovie(for: title)
            DispatchQueue.main.async {
                filmList.append(newMovie)
            }
        }
    }
    return filmList
}
