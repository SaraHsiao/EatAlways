//
//  RestaurantViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/16.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tableViewRestaurant: UITableView!
    @IBOutlet weak var searchRestaurant: UISearchBar!
    
    var restaurants = [Restaurant]()
    // For searchBar of result
    var filteredRestaurants = [Restaurant]()
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadRestaurants()
    }
    
    func loadRestaurants() {
        
        showActivityIndicator()
        
        APIManager.shared.getRestaurants { (json) in
            if (json != nil) {
                print(json)
                self.restaurants = []
                if let listRes = json["restaurants"].array {
                    for item in listRes {
                        let restaurant = Restaurant(json:item)
                        self.restaurants.append(restaurant)
                    }
                    self.tableViewRestaurant.reloadData()
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    func loadImage(imageView: UIImageView, urlString: String) {
        let imgURL: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
        }.resume()
    }
    
    // For ActivityIndicator of `show``
    func showActivityIndicator() {
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    // For ActivityIndicator of `hide`
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

// Delegate for SearchBar
extension RestaurantViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRestaurants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return ((res.name?.lowercased().range(of: searchText.lowercased())) != nil)
        })
        self.tableViewRestaurant.reloadData()
    }
}

// Delegate for UITableView
extension RestaurantViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchRestaurant.text != "" {
            return self.filteredRestaurants.count
        }
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantViewCell
        let restaurant: Restaurant
        
        if searchRestaurant.text != "" {
            restaurant = filteredRestaurants[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        
        cell.lblRestaurantName.text = restaurant.name!
        cell.lblRestaurantAddress.text = restaurant.address!
        
        if let logoName = restaurant.logo {
            let url = "\(logoName)"
            loadImage(imageView: cell.imgResaurantLogo, urlString: url)
        }
        return cell
    }
}
