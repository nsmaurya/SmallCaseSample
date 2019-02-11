//
//  DetailViewModel.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation

//MARK:- Movie Search Protocol
protocol SCDetailProtocol: class {
    func didReceiveDetailData(_ data: (String?, String?, String?, String?))
    func didFailToReceiveDetailData(errorString: String)
}
protocol SCHistoricalDetailProtocol: class {
    func didReceiveHistoricalDetailData(points: [SCIDHistoricalDataPoint])
    func didFailToReceiveHistoricalDetailData(errorString: String)
}
class SMDetailViewModel {
    
    private var scID: String
    private var scMainObject: SCMainObject?
    private var smallCaseIDDetail: SCIDDetail?
    private var smallCaseIDHistoricalDetail: SCIDHistoricalDetail?
    
    weak var detailDelegate: SCDetailProtocol?
    weak var historicalDetailDelegate: SCHistoricalDetailProtocol?
    
    init(scID: String, scMainObject: SCMainObject?) {
        self.scID = scID
        self.scMainObject = scMainObject
    }
    
    //MARK:- Get Details
    func getDetails() {
        let realmManager = RealmManager()
        if let data: SCIDDetail = realmManager.getDetails(scID: self.scID) {//checking for DB
            self.smallCaseIDDetail = data
            self.detailDelegate?.didReceiveDetailData(self.getBasicInfo())
        } else {
            APIManager.sharedInstance.getData(urlString: SmallCaseURLs.singleSmallCase, parameter: self.scID, onSuccess: { (data) in
                do {
                    let jsonDecoder = JSONDecoder()
                    self.smallCaseIDDetail = try jsonDecoder.decode(SCIDDetail.self, from: data)
                    //saving to realm
                    if let object: SCIDDetail = self.smallCaseIDDetail {
                        realmManager.save(object: object)
                    }
                    self.detailDelegate?.didReceiveDetailData(self.getBasicInfo())
                } catch {
                    self.detailDelegate?.didFailToReceiveDetailData(errorString: "Fail to ReceiveData")
                }
                
            }) { (error) in
                self.detailDelegate?.didFailToReceiveDetailData(errorString: error.localizedDescription)
            }
        }
    }
    
    private func getBasicInfo() -> (String?, String?, String?, String?) {
        var indexValue: String?
        var yearlyReturnValue: String?
        var monthlyReturnValue: String?
        var rationaleValue: String?
        if let index: Double = self.smallCaseIDDetail?.data?.stats?.indexValue?.value {
            indexValue = index.toString()
        }
        if let yearlyValue: Double = self.smallCaseIDDetail?.data?.stats?.returns?.yearly?.value {
            yearlyReturnValue = yearlyValue.toString()
        }
        if let yearlyValue: Double = self.smallCaseIDDetail?.data?.stats?.returns?.yearly?.value {
            yearlyReturnValue = yearlyValue.toString()
        }
        if let monthlyValue: Double = self.smallCaseIDDetail?.data?.stats?.returns?.monthly?.value {
            monthlyReturnValue = monthlyValue.toString()
        }
        if let rationale: String = self.smallCaseIDDetail?.data?.rationale {
            rationaleValue = rationale.htmlToString
        }
        return (indexValue, yearlyReturnValue, monthlyReturnValue, rationaleValue)
    }
    
    //MARK:- Get Historical Details
    func getHistoricalDetails() {
        let realmManager = RealmManager()
        if let data: SCIDHistoricalDetail = realmManager.getHistoricalDetails(scID: self.scID) {//checking for DB
            self.smallCaseIDHistoricalDetail = data
            self.historicalDetailDelegate?.didReceiveHistoricalDetailData(points: self.getPointsArray())
        } else {
            APIManager.sharedInstance.getData(urlString: SmallCaseURLs.singleSmallCaseHistorical, parameter: self.scID, onSuccess: { (data) in
                do {
                    let jsonDecoder = JSONDecoder()
                    self.smallCaseIDHistoricalDetail = try jsonDecoder.decode(SCIDHistoricalDetail.self, from: data)
                    //saving to realm: since graph is showing up to date value so not storing it in Realm
                    /*if let object: SCIDHistoricalDetail = self.smallCaseIDHistoricalDetail {
                        realmManager.save(object: object)
                    }*/
                    self.historicalDetailDelegate?.didReceiveHistoricalDetailData(points: self.getPointsArray())
                    
                } catch {
                    self.historicalDetailDelegate?.didFailToReceiveHistoricalDetailData(errorString: "Error in fetching historical data")
                }
                
            }) { (error) in
                self.historicalDetailDelegate?.didFailToReceiveHistoricalDetailData(errorString: error.localizedDescription)
            }
        }
    }
    
    private func getPointsArray() -> [SCIDHistoricalDataPoint] {
        var pointsArray = [SCIDHistoricalDataPoint]()
        if let pointArray = self.smallCaseIDHistoricalDetail?.data?.pointList, let arr = Array(pointArray) as? [SCIDHistoricalDataPoint] {
            pointsArray = arr
        }
        return pointsArray
    }
    
    //MARK:- Get downloaded image
    func getImageData() -> Data? {
        return self.scMainObject?.imageData
    }
    
    //MARK:- Get image url
    func getSCIDImage() -> (url: URL?, scMainObject: SCMainObject?) {
        return (url: imageUrl(scid: self.scID), scMainObject: scMainObject)
    }
}
