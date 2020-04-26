//
//  ListView.swift
//  tvDB swiftUI
//
//  Created by Morvay Balázs on 2020. 03. 03..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var movies = MovieList(with: ["Agymenok", "Matrix", "CSI: Miami", "Castle", "Lucifer"])

    var body: some View {
        NavigationView {
            List(movies.items) { film in
                NavigationLink(destination: MovieView(movie: film)) {
                    MovieListRowView(movie: film)
                }
            }.navigationBarTitle("What to watch")
        }
        .padding()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

