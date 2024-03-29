//
//  MovieListRowView.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 03. 11..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI


struct MovieListRowView: View {
    
    @ObservedObject var movie: Movie
    
    var body: some View {
        HStack() {
            Image(uiImage: movie.image)
                .resizable()
                .frame(width: 40.0, height: 40.0, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 4))
                .shadow(radius: 5)

            Text(movie.title).frame(alignment: .leading)
            Spacer()
        
            Text(movie.IMDBRating).font(.headline).fontWeight(.bold).foregroundColor(Color.blue).multilineTextAlignment(.leading).scaledToFit().opacity(0.8).shadow(radius: 10)
        }
        .padding(.trailing).padding(.leading)
    }
}

struct MovieListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListRowView(movie: Movie())
    }
}
