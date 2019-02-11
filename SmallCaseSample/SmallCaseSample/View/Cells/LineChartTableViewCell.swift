//
//  LineChartTableViewCell.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import UIKit
import Charts

class LineChartTableViewCell: UITableViewCell {

    @IBOutlet weak var lineChartView: LineChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureChart(points: [SCIDHistoricalDataPoint]) {
        var datePoints: [String] = [String]()
        var values: [Double] = [Double]()
        for point in points {
            datePoints.append(point.date ?? "")
            values.append(point.index?.value ?? 0.0)
        }
        self.setChart(dataPoints: datePoints, values: values)
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Small Case History")
        let lineChartData = LineChartData(dataSets: [lineChartDataSet])
        lineChartView.data = lineChartData
    }

}
