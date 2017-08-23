//
//  DriverOrderViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/23.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit

class DriverOrderViewController: UITableViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var orders = [DriverOrder]()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadReadyOrders()
    }
    
    func loadReadyOrders() {
        
        Helpers.showActivityIndicator(self.activityIndicator, self.view)
        
        APIManager.shared.getDriverOrders { (json) in
            print(json)
            
            if (json != nil) {
                self.orders = []
                if let readyOrders = json["orders"].array {
                    for item in readyOrders {
                        let order = DriverOrder(json:item)
                        self.orders.append(order)
                    }
                }
                self.tableView.reloadData()
                Helpers.hideActivityIndicator(self.activityIndicator)
            }
        }
    }
    
    private func pickOrder(orderId:Int) {
        
        APIManager.shared.pickOrder(orderId: orderId) { (json) in
            
            if let status = json["status"].string {
                
                switch status {
                case "fail":
                    // Showing an alert saying Error
                    let alertView = UIAlertController(title: "Error", message: String(describing: json["error"]), preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    alertView.addAction(cancelAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                default:
                    
                    // Showing an alert saying Success
                    let alertView = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Show my map", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "CurrentDelivery", sender: self)
                    })
                    
                    alertView.addAction(okAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverOrdersCell", for: indexPath) as! DriverOrderCell
        
        let order = orders[indexPath.row]
        cell.lblRestaurantName.text = order.restaurantName
        cell.lblCustomerName.text = order.customerName
        cell.lblCustomerAddress.text = order.customerAddress
        cell.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: order.customerAvatar!)!))
        cell.imgCustomerAvatar.layer.cornerRadius = 50 / 2
        cell.imgCustomerAvatar.layer.borderWidth = 1.0
        cell.imgCustomerAvatar.layer.borderColor = UIColor.green.cgColor
        cell.imgCustomerAvatar.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let order = orders[indexPath.row]
        self.pickOrder(orderId: order.id!)
    }
}

