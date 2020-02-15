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
    
    var _request: DataRequest?
    var request: DataRequest? {
        get {
            return _request!
        }
        set {
            if let prevRequest = _request {
                prevRequest.cancel()
            }
            _request = newValue
        }
    }
    
    var data = [People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = Array(Prefs.recents)
        tableView.reloadData()
        
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let model = self.data[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "Character"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        if !(searchBar.text?.isEmpty ?? true) {
            Prefs.recents.insert(model)
        }
        performSegue(withIdentifier: "infoSegue", sender: model)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        guard searchBar.text?.isEmpty ?? true else {
            return UISwipeActionsConfiguration(actions: [])
        }
        let deleteAction = UIContextualAction(
            style: .destructive,
            title:  "Delete",
            handler: { (ac: UIContextualAction, view :UIView, success: (Bool) -> Void) in
                Prefs.recents.remove(self.data[indexPath.row])
                self.data.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                success(true)
        })
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegue" {
            if let peopleController = segue.destination as? PeopleController {
                peopleController.startModel = sender as? People
            }
        }
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
            request = nil
            self.searchBar.isLoading = false
            self.data = Array(Prefs.recents)
            self.tableView.reloadData()
            return
        }
        
        self.searchBar.isLoading = true
        
        request = AF.request("https://swapi.co/api/people/?search=\(query)", method: .get)
            .responseObject { (response: AFDataResponse<PeopleResponse>) in
                switch response.result {
                case .success(let peopleResponse):
                    self.data.removeAll()
                    if let results = peopleResponse.results {
                        self.data = results
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.searchBar.isLoading = false
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
                    let newActivityIndicator = UIActivityIndicatorView(style: .medium)
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
