//
//  Models.swift
//  epam_star_wars
//
//  Created by Nickolay Truhin on 12.02.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import Foundation
import ObjectMapper

class PeopleResponse: Mappable {
    var count: Int?
    var results: [People]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        count <- map["count"]
        results <- map["results"]
    }
}

class People: Hashable, Mappable, Codable {
    var name: String?
    var height: String?
    var mass: String?
    var eyeColor: String?
    var birthYear: String?
    var gender: String?
    var hairColor: String?
    var skinColor: String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        name <- map["name"]
        height <- map["height"]
        mass <- map["mass"]
        eyeColor <- map["eye_color"]
        birthYear <- map["birth_year"]
        gender <- map["gender"]
        hairColor <- map["hair_color"]
        skinColor <- map["skin_color"]
    }
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    static func == (lhs: People, rhs: People) -> Bool {
        return lhs.name == rhs.name
    }
}
