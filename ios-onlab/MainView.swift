//
//  MainView.swift
//  ios-onlab
//
//  Created by Morvay Balázs on 2020. 05. 24..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "tv")
                    Text("on TV")
            }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
