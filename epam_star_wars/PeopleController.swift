//
//  PeopleController.swift
//  epam_star_wars
//
//  Created by Nickolay Truhin on 13.02.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import UIKit

class PeopleController: UITableViewController {
    var startModel: People?
    var _jsonModel: [String: Any]?
    var jsonModel: [String: Any] {
        get {
            if _jsonModel == nil {
                _jsonModel = startModel?.toJSON() ?? [:]
            }
            return _jsonModel!
        }
        
        set {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = startModel {
            title = model.name
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.tableView:
        return jsonModel.keys.count
        default:
          return 0
       }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let json = Array(jsonModel.enumerated())[indexPath.row].element
        cell.textLabel?.text = json.key.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter()
        cell.detailTextLabel?.text = json.value as? String
        return cell
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
