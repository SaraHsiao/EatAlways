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
    
    
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var meal: Meal?
    var qty = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeal()
    }
    
    func loadMeal () {
        
        if let price = meal?.price {
            lblTotal.text = "$\(price)"
        }
        
        
        lblMealName.text = meal?.name
        lblShortDescription.text = meal?.short_description
        
        if let imageUrl = meal?.image {
            Helpers.loadImage(imgMeal, "\(imageUrl)")
        }
    }
    
    @IBAction func addQty(_ sender: UIButton) {
        
        if (qty < 99) {
            qty += 1
            lblQty.text = String(qty)
            
            if let price = meal?.price {
                lblTotal.text = "$\(price * Float(qty))"
            }
        }
    }
    
    @IBAction func removeQty(_ sender: UIButton) {
        
        if (qty >= 2) {
            qty -= 1
            lblQty.text = String(qty)
            
            if let price = meal?.price {
                lblTotal.text = "$\(price * Float(qty))"
            }
        }
    }
    
    @IBAction func addToTray(_ sender: UIButton) {
        
        // Image animating into ButtonBarItem
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        image.image = UIImage(named: "button_chicken")
        image.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height-100)
        self.view.addSubview(image)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {image.center = CGPoint(x:self.view.frame.width-40, y:24)}) { _ in
                        image.removeFromSuperview()}
    }
}
