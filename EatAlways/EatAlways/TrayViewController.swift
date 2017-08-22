//
//  TrayViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/16.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import MapKit

class TrayViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewMeals: UITableView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewMap: UIView!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var txtFieldAddress: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var btnAddPayment: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if (Tray.currentTray.items.count == 0) {
            
            // Showing a message here
            let lblEmptyTray = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            lblEmptyTray.center = self.view.center
            lblEmptyTray.textAlignment = .center
            lblEmptyTray.text = "Your tray is Empty. Pls select some meal."
            
            self.view.addSubview(lblEmptyTray)
            
        } else {
            
            // Display all of the UI controllers
            self.tableViewMeals.isHidden = false
            self.viewTotal.isHidden = false
            self.viewAddress.isHidden = false
            self.viewMap.isHidden = false
            self.btnAddPayment.isHidden = false
            
            loadMeals()
        }
    }
 
    func loadMeals() {
        self.tableViewMeals.reloadData()
        self.lblTotal.text = "$\(Tray.currentTray.getTotal())"
    }
    
    @IBAction func addPayment(_ sender: UIButton) {
        
        if (self.txtFieldAddress.text == "") {
            
            // Showing alert that this field is required
            let alertController = UIAlertController(title: "No Address", message: "Address is required", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                self.txtFieldAddress.becomeFirstResponder()
            })
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Tray.currentTray.address = self.txtFieldAddress.text
            self.performSegue(withIdentifier: "AddPayment", sender: self)
        }
    }
}

extension TrayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tray.currentTray.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrayItemCell", for: indexPath) as! TrayViewCell
        
        let tray = Tray.currentTray.items[indexPath.row]
        cell.lblQty.text = "\(tray.qty)"
        cell.lblMealName.text = tray.meal.name
        cell.lblSubTotal.text = "$\(tray.meal.price! * Float(tray.qty))"
        return cell
    }
    
}
