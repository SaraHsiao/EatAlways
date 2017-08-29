//
//  StatisticViewController.swift
//  EatAlways
//
//  Created by KaFeiDou on 2017/8/24.
//  Copyright © 2017年 KaFeiDou. All rights reserved.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var viewChart: BarChartView!
    
    var weekdays = ["Sun","Mon","Tue","Wed","Thurs","Fri","Sat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // 1.Initialize Chart
        self.initializeChart()
        
        // 2. Load Data to Charts
        self.loadDataToChart()
    }
    
    func initializeChart() {
        
        viewChart.noDataText = "No Data"
        viewChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        viewChart.xAxis.labelPosition = .bottom
        viewChart.descriptionText = ""
        
        viewChart.legend.enabled = false
        viewChart.scaleXEnabled = false
        viewChart.scaleYEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false
        
        viewChart.leftAxis.axisMinValue = 0.0
        viewChart.leftAxis.axisMaxValue = 100.0
        viewChart.highlighter = nil
        viewChart.rightAxis.enabled = false
        viewChart.xAxis.drawGridLinesEnabled = false
    }
    
    func loadDataToChart() {
        
        APIManager.shared.getDriverRevenue { (json) in
            if (json != nil) {
                let revenue = json["revenue"]
                
                var dataEntries: [BarChartDataEntry] = []
                
                for i in 0..<self.weekdays.count {
                    let day = self.weekdays[i]
                    let dataEntry = BarChartDataEntry(x: revenue[day].double!, yValues: [Double(i)])
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "Revenue a day")
                chartDataSet.colors = ChartColorTemplates.material()
                
                let chartData = BarChartData(dataSet: chartDataSet)
                
                self.viewChart.data = chartData
            }
        }
    }
    
}
