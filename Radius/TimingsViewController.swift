//
//  TimingsViewController.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//

import UIKit
import Charts
import SwiftUI

class TimingsViewController: UIViewController, ChartViewDelegate {

    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 15, y: 100, width: self.view.frame.size.width - 30, height: self.view.frame.size.width * 3/4)
        barChart.center = view.center
        barChart.animate(xAxisDuration: 0.1, yAxisDuration: 0.75)
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry()]
        
        var nums = [4, 15, 24, 33, 36, 50, 47, 41, 22, 23, 13, 6]
        // 30, 47, 24, 35, 37, 41, 35, 26, 50, 33, 22, 24
        for x in 0..<12 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(nums[x])))
        }
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBSegueAction func swiftUIAction(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: NewView())
    }

}
