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
    
    var restaurants = [Restaurant]()
    var filteredRestaurants = [Restaurant]()        // for search of result
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        APIManager.shared.getRestaurants { (json) in
            if (json != nil) {
                print(json)
                self.restaurants = []
                if let listRes = json["restaurants"].array {
                    for item in listRes {
                        let restaurant = Restaurant(json:item)
                        self.restaurants.append(restaurant)
                    }
                }
            }
        }
    }
}
extension RestaurantViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        
        return cell
    }
}
