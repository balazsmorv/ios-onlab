//
//  SettingsView.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 05. 24..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

struct Selector: View {
    
    @EnvironmentObject var movies: MovieList
    var row: Channel
    @Binding var selectedRows: Set<UUID>
    
    var isSelected: Bool {
        selectedRows.contains(row.id)
    }
    
    var body: some View {
        HStack {
            Text(self.row.name)
                .font(.title)
                .fontWeight(.regular)
            Spacer()
            if self.isSelected {
                Text("✔️")
            }
        }
        .onTapGesture {
            if self.isSelected {
                self.selectedRows.remove(self.row.id)
                var channelList = self.movies.tvGuide.userSelectedChannels
                channelList.removeAll(where: {$0.id == self.row.id})
            } else {
                self.selectedRows.insert(self.row.id)
                self.movies.tvGuide.userSelectedChannels.append(self.row)
            }
        }
    }
    
}

struct SettingsView: View {
    
    @EnvironmentObject var movies: MovieList
    @State var selectedChannels = Set<UUID>()
    
    var body: some View {
        NavigationView {
            List(movies.availableChannels, selection: $selectedChannels) { channel in
                Selector(row: channel, selectedRows: self.$selectedChannels)
            }
            .navigationBarTitle(Text("Selected \(selectedChannels.count) channels"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
