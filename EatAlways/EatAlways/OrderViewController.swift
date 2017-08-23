//
//  OrderViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/16.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON


class OrderViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tableViewMeals: UITableView!
    
    var tray = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
            getLatestOrder()
        }
    }
    
    func getLatestOrder() {
        APIManager.shared.getLatestOrder { (json) in
            print(json)
            if let orderDetail = json["order"]["order_details"].array {
                self.tray = orderDetail
                self.tableViewMeals.reloadData()
            }
        }
    }
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as! OrderViewCell
        let item = tray[indexPath.row]
        cell.lblQty.text = String(item["quantity"].int!)
        cell.lblMealName.text = item["meal"]["name"].string
        cell.lblSubTotal.text = "$\(String(item["sub_total"].float!))"
        
        return cell
    }
}
