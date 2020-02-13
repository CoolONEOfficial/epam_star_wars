//
//  Prefs.swift
//  epam_star_wars
//
//  Created by Nickolay Truhin on 13.02.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import Foundation

class Prefs {
    static private var _recents: [People]?
    
    static var recents: [People] {
        get {
            if _recents == nil {
                if let data = UserDefaults.standard.value(forKey:"recents") as? Data {
                    _recents = try! PropertyListDecoder().decode(Array<People>.self, from: data)
                } else {
                    _recents = []
                }
            }
            return _recents!
        }
        set {
            _recents = newValue
            UserDefaults.standard.set(try? PropertyListEncoder().encode(_recents), forKey:"recents")
        }
    }
}
