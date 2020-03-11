//
//  ListView.swift
//  tvDB swiftUI
//
//  Created by Morvay Balázs on 2020. 03. 03..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    let filmList = [Request.getMovie(for: "Mátrix"),
                    Request.getMovie(for: "Mentalista"),
                    Request.getMovie(for: "Agymenok"),
                    Request.getMovie(for: "Sonic, a sündisznó"),
                    Request.getMovie(for: "Baratok kozt"),
                    Request.getMovie(for: "Noi szervek"),
                    Request.getMovie(for: "Avatár")].sorted {$0.IMDBRating > $1.IMDBRating}
    
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filmList) { section in
                    HStack {
                        Image(uiImage: getPosterImage(from: section.poster))
                        .resizable()
                        .frame(width: 40.0, height: 40.0, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 4))
                        .shadow(radius: 10)

                        Text(section.title).frame(alignment: .leading)
                        Spacer()
                
                    Text(section.IMDBRating).font(.headline).fontWeight(.bold).foregroundColor(Color.blue).multilineTextAlignment(.leading).scaledToFit().opacity(0.8).shadow(radius: 10)
                    }
                    .padding(.leading).padding(.trailing)
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

