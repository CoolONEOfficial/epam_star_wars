//
//  HomeController.swift
//  epam_star_wars
//
//  Created by Nickolay Truhin on 12.02.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class HomeController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var testTable: UITableView!
    var spinnerWrapperView: UIView?
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.tableView:
          return self.data.count
        default:
          return 0
       }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
       cell.textLabel?.text = self.data[indexPath.row]
       return cell
    }
}

extension HomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }

    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            self.searchBar.isLoading = false
            self.data.removeAll()
            return
        }
        
        self.searchBar.isLoading = true
        
        AF.request("https://swapi.co/api/people/?search=\(query)", method: .get)
            .responseObject { (response: AFDataResponse<PeopleResponse>) in
                let peopleResponse = try? response.result.get()

                self.data.removeAll()
                if let results = peopleResponse?.results {
                    for result in results {
                        if let name = result.name {
                            self.data.append(name)
                        }
                    }
                    
                    self.searchBar.isLoading = false
                    self.tableView.reloadData()
                }
        }
    }
}

// Extension for UIActivityIndicatorView in UISearchBar from stackoverflow
extension UISearchBar {
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
           if let textField = value(forKey: "searchField") as? UITextField {
                return textField
            }
            return nil
        }
    }

    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }

    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    newActivityIndicator.startAnimating()
                    if #available(iOS 13.0, *) {
                        newActivityIndicator.backgroundColor = UIColor.systemGroupedBackground
                    } else {
                        newActivityIndicator.backgroundColor = UIColor.groupTableViewBackground
                    }
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
