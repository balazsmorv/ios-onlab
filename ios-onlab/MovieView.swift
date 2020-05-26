//
//  MovieView.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 03. 10..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

struct MovieView: View {
    
    @ObservedObject var movie: Movie
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                Image(uiImage: self.movie.image)
                .resizable()
                    .frame(width: geo.size.width * 0.9)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 4))
                .shadow(radius: 10)
            }
                
            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding([.top, .leading, .trailing])
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            
            HStack {
                Text("\(movie.IMDBRating)/10")
                    .font(.title)
                    .fontWeight(.light)
                    .shadow(radius: 20)
                Spacer()
                Text(movie.channel)
                    .font(.title)
                    .fontWeight(.light)
                    .shadow(radius: 20)
            }.padding(.leading).padding(.trailing)
        }.padding(.bottom)
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movie: Movie())
    }
}


