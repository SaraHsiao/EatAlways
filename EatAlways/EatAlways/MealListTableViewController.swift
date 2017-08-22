//
//  MealListTableViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/16.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class MealListTableViewController: UITableViewController {
    
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurant?.name

        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        
        return cell
    }
    
}
