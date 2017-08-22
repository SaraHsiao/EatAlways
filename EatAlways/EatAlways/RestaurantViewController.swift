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
        
        Helpers.showActivityIndicator(activityIndicator, view)
        
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
                    Helpers.hideActivityIndicator(self.activityIndicator)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MealList" {
            let controller = segue.destination as! MealListTableViewController
            controller.restaurant = restaurants[(tableViewRestaurant.indexPathForSelectedRow?.row)!]
        }
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
            Helpers.loadImage(cell.imgResaurantLogo, "\(logoName)")
        }
        return cell
    }
}
