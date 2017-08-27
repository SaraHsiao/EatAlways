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
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    var tray = [JSON]()
    var destination:MKPlacemark?
    var source:MKPlacemark?
    
    var driverPin:MKPointAnnotation!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        getLatestOrder()
    }
    
    func getLatestOrder() {
        
        APIManager.shared.getLatestOrder { (json) in
            
            let order = json["order"]
            if order["status"] != nil {
                if let orderDetails = order["order_details"].array {
                    
                    self.lblStatus.text = json["status"].stringValue.uppercased()
                    self.tray = orderDetails
                    self.tableViewMeals.reloadData()
                }
                
                let from = order["restaurant"]["address"].stringValue
                let to = order["address"].stringValue
                
                self.getLocation(from, "RES", completionHandler: { (sou) in
                    self.source = sou
                    
                    self.getLocation(to, "CUS", completionHandler: { (des) in
                        self.destination = des
                        self.getDirections()
                    })
                })
                
                if order["status"] != "Delivered" {
                    self.setTimer()
                }
            }
        }
    }
    
    func setTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getDriverLocation(_:)), userInfo: nil, repeats: true)
    }
    
    func getDriverLocation (_ sender:AnyObject) {
        
        APIManager.shared.getDrvierLocation { (json) in
            if let location = json["location"].string {
                self.lblStatus.text = "ON THE WAY"
                
                let split = location.components(separatedBy: ",")
                let lat = split[0]
                let lng = split[1]
                
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lng)!)
                
                // Create pin Annotation for Driver
                if (self.driverPin != nil) {
                    self.driverPin.coordinate = coordinate
                } else {
                    self.driverPin = MKPointAnnotation()
                    self.driverPin.coordinate = coordinate
                    self.driverPin.title = "DRI"
                    self.map.addAnnotation(self.driverPin)
                }
                // Reset Zoom Rect to Cover 3 Locations
                self.autoZoom()
            } else {
                self.timer.invalidate()
            }
        }
    }
    
    func autoZoom() {
        
        var zoomRect = MKMapRectNull
        for annotation in self.map.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let optionRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, optionRect)
        }
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
        self.map.setVisibleMapRect(insetRect, animated: true)
    }
}

extension OrderViewController:MKMapViewDelegate {
    
    // 1. Delegate method of MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
    // 2. Convert an address string to the location on the map
    func getLocation(_ address: String, _ title: String, completionHandler: @escaping (MKPlacemark) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if (error != nil) {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Create a Pin on Map
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                
                self.map.addAnnotation(dropPin)
                completionHandler(MKPlacemark(placemark: placemark))
            }
        }
    }
    
    // 3. Get Direction and zoom to address
    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem.init(placemark: source!)
        request.destination = MKMapItem.init(placemark: destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if (error != nil) {
                print("Error:", error)
                
            } else {
                
                // Show route
                self.showRoute(response: response!)
            }
        }
    }
    
    // 4. Show route between location and make a visible zoom
    func showRoute(response: MKDirectionsResponse) {
        
        for ruote in response.routes {
            self.map.add(ruote.polyline, level:MKOverlayLevel.aboveRoads)
        }
    }
    
    // 5. Customise Pin Point with Image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "MYPin"
        var annotationView:MKAnnotationView?
        
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeueAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        if let annotationView = annotationView, let name = annotation.title! {
            switch name {
                case "DRI":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
                case "RES":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_restaurant")
                case "CUS":
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_customer")
            default:
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "pin_car")
            }
        }
        return annotationView
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
