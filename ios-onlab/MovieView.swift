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
            Text("")
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
