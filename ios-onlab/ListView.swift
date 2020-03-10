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
                    Request.getMovie(for: "Baratok kozt")].sorted {$0.IMDBRating > $1.IMDBRating}
    
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filmList) { section in
                    HStack {
                        Text(section.title).frame(alignment: .leading)
                        Spacer()
                        Text(section.IMDBRating).font(.headline).fontWeight(.bold).foregroundColor(Color.blue).multilineTextAlignment(.leading).scaledToFit().opacity(0.8).shadow(radius: 10)
                    }
                    .padding(.leading)
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
