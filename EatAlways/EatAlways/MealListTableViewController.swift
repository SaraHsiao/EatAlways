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
    var meals = [Meal]()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurant?.name
        }
        loadMeals()
    }
    
    // List of Meal
    func loadMeals() {
        
        Helpers.showActivityIndicator(activityIndicator, self.view)
        
        if let restaurantId = restaurant?.id {
            
            APIManager.shared.getMeals(restaurantId: restaurantId, completionHandler: { (json) in
                print(json)
                
                if (json != nil) {
                    self.meals = []
                    
                    if let tempMeals = json["meals"].array {
                        for item in tempMeals {
                            let meal = Meal(json: item)
                            self.meals.append(meal)
                        }
                        self.tableView.reloadData()
                        Helpers.hideActivityIndicator(self.activityIndicator)
                    }
                }
            })
        }
    }
    
    // Use segue transfer to MealDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "MealDetails") {
            let controller = segue.destination as! MealDetailViewController
            controller.meal = meals[(tableView.indexPathForSelectedRow?.row)!]
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealViewCell
        
        let meal = meals[indexPath.row]
        cell.lblMealName.text = meal.name
        cell.lblMealShortDescriptions.text = meal.short_description
        
        if let price = meal.price {
            cell.lblPrice.text = "$\(price)"
        }
        
        if let image = meal.image {
            Helpers.loadImage(cell.imgMealImage, "\(image)")
        }
        return cell
    }
    
}
