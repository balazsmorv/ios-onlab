//
//  ContentView.swift
//  tvDB swiftUI
//
//  Created by Morvay Balázs on 2020. 02. 20..
//  Copyright © 2020. BME AUT. All rights reserved.
//

//import SwiftUI
//
//struct ContentView: View {
//    
//    @State private var title: String = ""
//    @State private var score: String = "?"
//    
//    var body: some View {
//        VStack {
//            Text("TVDB").foregroundColor(.red).font(.largeTitle)
//            HStack {
//                TextField("Movie or series", text: $title).textFieldStyle(RoundedBorderTextFieldStyle())
//                Text("IMDB score: \(score)")
//            }.padding()
//            Button(action: {
//                let idData = Request.getID(for: self.title)
//                let idRequest = try! JSONDecoder().decode(IDInfo.self, from: idData!)
//                print(idRequest)
//                let data = Request.makeRequest(with: idRequest.titles[0].id)
//                let movie = try! JSONDecoder().decode(MovieInfo.self, from: data!)
//                self.score = movie.IMDBRating
//            }) {
//                Text("Search")
//            }
//            .foregroundColor(.blue).font(.body)
//            .cornerRadius(CGFloat(0.33))
//            
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
