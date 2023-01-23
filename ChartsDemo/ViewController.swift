//
//  ViewController.swift
//  ChartsDemo
//
//  Created by Jacob Case on 1/22/23.
//

import UIKit
import Charts

/*
 Demo setup to understand charts for implementation into larger project.
 This app uses a simple text field & button to submit data to the chart view. After submitting a Y data point, a matching X data point in the format of a date (numeric in this case) will be added.
 
 Purpose of this is to gain an understanding of how to create a "weekly minutes practice" plot.
 
 */

class myValueFormatter : IndexAxisValueFormatter {
    override func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        return "\(Int(value))"
    }
}

class ViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var btButton: UIButton!
    @IBOutlet weak var chtChart: LineChartView!
    @IBOutlet weak var textField: UITextField!
    

    var numbers = [Double]()
    var times = [String]()
    public let days: [String] = {
        var days = [String]()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        
        for i in 1...7 {
            let day = cal.component(.day, from: date)
            days.append("\(day)")
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        
        return days.reversed()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateGraph()
    }
    
    @IBAction func btButton(_sender: Any) {
        //get data from text field
        let input = Double(textField.text!)
        
        numbers.append(input!)
        print(numbers)
        updateGraph()
    }
    
    func updateGraph() {
        
        //create a chart entry
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: numbers[i])
            lineChartEntry.append(value)
        }
        
        //set the data of the line chart to the new entries
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "number")
        
        //configure/stylize chart
        line1.colors = [NSUIColor.blue]
        
        //assign dataset to chartData
        let lineData = LineChartData(dataSet: line1)
        
        //assign line data to the lineChartView
        chtChart.data = lineData
        chtChart.rightAxis.enabled = false
        
        //adjust axis properties
        let xAxis = chtChart.xAxis
        
        //pull
        xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        xAxis.granularity = 1.0
        xAxis.labelPosition = .bottom
        //xAxis.labelCount = numbers.count
        xAxis.drawGridLinesEnabled = false
        
        
        let yAxis = chtChart.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 12)
        yAxis.labelPosition = .outsideChart
        
        
        chtChart.xAxis.labelPosition = .bottom
        
        chtChart.chartDescription.text = "awesome chart"
    }
}
