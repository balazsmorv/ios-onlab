//
//  IDRequest.swift
//  onTV
//
//  Created by Morvay Balázs on 2020. 02. 13..
//  Copyright © 2020. BME AUT. All rights reserved.
//

import Foundation


struct Element: Decodable {
    
    var title: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case id = "id"
    }
}


struct IDInfo: Decodable {
    
    var titles: [Element]
    var names: [Element]
    var companies: [Element]
    
    enum CodingKeys: String, CodingKey {
        case titles = "titles"
        case names = "names"
        case companies = "companies"
    }

}
