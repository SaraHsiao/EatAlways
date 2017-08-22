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
    var restaurant: Restaurant?
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
        
        let trayItem = TrayItem(meal: self.meal!, qty: self.qty)
        
        guard let trayRestaurant = Tray.currentTray.restaurant,
            // If those requirements are not match
            let currentRestaurant = self.restaurant else {
                
                Tray.currentTray.restaurant = self.restaurant
                Tray.currentTray.items.append(trayItem)
                return
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // If ordering meal from the same restaurant
        if (trayRestaurant.id == currentRestaurant.id) {
            let inTray = Tray.currentTray.items.index(where: { (item) -> Bool in
                return item.meal.id! == trayItem.meal.id!
            })
            
            if let index = inTray {
                let alertView = UIAlertController(title: "Add more?", message: "Your tray already has this meal.Do you want more?", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "Add more", style: .default, handler: { (action:UIAlertAction!) in
                    Tray.currentTray.items[index].qty += self.qty
                })
                alertView.addAction(OKAction)
                alertView.addAction(cancelAction)
                
                self.present(alertView, animated: true, completion: nil)
            } else {
                Tray.currentTray.items.append(trayItem)
            }
        } else {
            let alertView = UIAlertController(title: "Start new tray?", message: "Your ordering meal from another restaurant. Would you like to clear the current tray?", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "New Tray", style: .default, handler: { (action:UIAlertAction!) in
                Tray.currentTray.items = []
                Tray.currentTray.items.append(trayItem)
                Tray.currentTray.restaurant = self.restaurant
            })
            alertView.addAction(OKAction)
            alertView.addAction(cancelAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
}
