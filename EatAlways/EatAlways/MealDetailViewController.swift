//
//  MealDetailViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/16.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var lblMealName: UILabel!
    @IBOutlet weak var lblShortDescription: UILabel!
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeal()
    }
    
    func loadMeal () {
        
        lblMealName.text = meal?.name
        lblShortDescription.text = meal?.short_description
        
        if let imageURL = meal?.image {
            Helpers.loadImage(imgMeal, "\(imageURL)")
        }
    }
}
