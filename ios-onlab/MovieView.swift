//
//  MovieView.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 03. 10..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

var list = MovieList()


struct MovieView: View {
    
    @ObservedObject var movie: Movie
    
    var body: some View {
        VStack {
            Image(uiImage: movie.image)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 4))
                .shadow(radius: 10)
            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding([.top, .leading, .trailing])
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Text(movie.IMDBRating)
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.black)
                .shadow(radius: 20)
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movie: list.items[0])
    }
}


