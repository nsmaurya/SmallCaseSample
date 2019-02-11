//
//  SMDetailViewController.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import UIKit

class SMDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkInfoLabel: UILabel!

    enum DetailTableRows:Int {case basicInfo = 0, rationale, history
        static let count: Int = {
            return DetailTableRows.history.rawValue + 1
        }()
    }
    var smDetailViewModel: SMDetailViewModel!
    var indexValue: String?
    var yearlyReturnValue: String?
    var monthlyReturnValue: String?
    var rationaleValue: String?
    var historicalData: [SCIDHistoricalDataPoint] = [SCIDHistoricalDataPoint]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        smDetailViewModel.detailDelegate = self
        smDetailViewModel.getDetails()
        smDetailViewModel.historicalDetailDelegate = self
        self.smDetailViewModel.getHistoricalDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initNetworkChecker()
    }
    
    //MARK:- Helper method
    private func initNetworkChecker() {
        let networkManager: NetworkManager = NetworkManager.sharedInstance
        networkManager.networkDelegate = self
        networkManager.initNetworkChecker()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SMDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailTableRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row: DetailTableRows = DetailTableRows.init(rawValue: indexPath.row) else {
            return 0
        }
        switch row {
        case .basicInfo:
            return Device.ScreenSize.width / 2
        case .history:
            return 400.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row: DetailTableRows = DetailTableRows.init(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch row {
        case .basicInfo:
            let cell: BasicInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoTableViewCell", for: indexPath) as! BasicInfoTableViewCell
            //setting info
            if let imageData: Data = self.smDetailViewModel.getImageData(), let image: UIImage = UIImage.init(data: imageData) {
                cell.detailImageView.image = image
            } else {
                let info = self.smDetailViewModel.getSCIDImage()
                if let url: URL = info.0 {
                    cell.detailImageView.loadImage(url: url, scMainObject: info.1)
                } else {
                    cell.detailImageView.image = nil
                }
            }
            cell.configureCell(indexValue: indexValue, yearlyReturnValue: yearlyReturnValue, monthlyReturnValue: monthlyReturnValue)
            return cell
        case .rationale:
            let cell: RationaleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RationaleTableViewCell", for: indexPath) as! RationaleTableViewCell
            cell.configureCell(rationaleValue: self.rationaleValue)
            return cell
        case .history:
            let cell: LineChartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LineChartTableViewCell", for: indexPath) as! LineChartTableViewCell
            cell.configureChart(points: self.historicalData)
            return cell
        }
    }
}

//MARK:- SCDetail Delegate
extension SMDetailViewController: SCDetailProtocol {
    func didReceiveDetailData(_ data: (String?, String?, String?, String?)) {
        self.indexValue = data.0
        self.yearlyReturnValue = data.1
        self.monthlyReturnValue = data.2
        self.rationaleValue = data.3
        self.reloadTable()
    }
    func didFailToReceiveDetailData(errorString: String) {
        //DialogManager.sharedInstance.showAlert(onViewController: self, withText: "Error!", withMessage: errorString, style: .alert)
    }
}

//MARK:- SCHistoricalDetail Delegate
extension SMDetailViewController: SCHistoricalDetailProtocol {
    func didReceiveHistoricalDetailData(points: [SCIDHistoricalDataPoint]) {
        self.historicalData = points
        self.reloadTable()
    }
    func didFailToReceiveHistoricalDetailData(errorString: String) {
        //DialogManager.sharedInstance.showAlert(onViewController: self, withText: "Error!", withMessage: errorString, style: .alert)
    }
}

//MARK:- Network Checker Delegate
extension SMDetailViewController: NetworkProtocol {
    func networkInfo(isNetworkAvailable: Bool, message: String) {
        self.networkInfoLabel.text = message
        if isNetworkAvailable {
            self.networkInfoLabel.backgroundColor = UIColor.green
        } else {
            self.networkInfoLabel.backgroundColor = UIColor.red
        }
    }
}
