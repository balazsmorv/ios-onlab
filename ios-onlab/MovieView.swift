//
//  MovieView.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 03. 10..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

struct MovieView: View {
    
    @State var movie: Movie
    @State var poster = UIImage()
    
    var body: some View {
        VStack {
            Image(uiImage: poster)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 4))
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
        }.onAppear() {
            self.poster = getPosterImage(from: self.movie.poster)
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movie: Request.getMovie(for: "Matrix"))
    }
}


func getPosterImage(from urlString: String) -> UIImage {
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            } else {
                return UIImage(named: "posterNotFound")!
            }
        } else {
            return UIImage(named: "posterNotFound")!
        }
        
    } else {
        return UIImage(named: "posterNotFound")!
    }
}
