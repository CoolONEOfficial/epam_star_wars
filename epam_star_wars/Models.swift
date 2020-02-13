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
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        count <- map["count"]
        results <- map["results"]
    }
}

class People: Mappable {
    var name: String?
    var height: String?
    var weight: String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        name <- map["name"]
        height <- map["height"]
        weight <- map["weight"]
    }
}
