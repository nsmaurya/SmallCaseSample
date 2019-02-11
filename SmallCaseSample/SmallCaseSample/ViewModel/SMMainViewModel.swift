//
//  MainVIewModel.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation

class SMMainViewModel {
    
    private var allSCObject: [SCMainObject]?
    
    init() {
        let realmManager: RealmManager = RealmManager()
        allSCObject = realmManager.getAllSCID()
    }
    
    //MARK:- Get Image URL at index
    func getSCIDImageUrl(index: Int) -> URL? {
        guard let scID: String = allSCObject?[index].scID else {
            return nil
        }
        return imageUrl(scid: scID)
    }
    
    //MARK:- Get all SCID count
    func getCount() -> Int {
        return allSCObject?.count ?? 0
    }
    
    //MARK:- Get Image Data at index
    func getSCIDImageData(index: Int) -> Data? {
        return allSCObject?[index].imageData
    }
    
    //MARK:- Get Detail View Model at index
    func getSCIDInfo(index: Int) -> SMDetailViewModel? {
        guard let scMainObject: SCMainObject = allSCObject?[index], let scID: String = scMainObject.scID else {
            return nil
        }
        
        let scDetailViewModel: SMDetailViewModel = SMDetailViewModel(scID: scID, scMainObject: scMainObject)
        return scDetailViewModel
    }
    
    //MARK:- Save downloaded image at index
    func saveDownloadedImage(index: Int, imageData: Data) {
        if let scObject: SCMainObject = allSCObject?[index] {
            let realmManager: RealmManager = RealmManager()
            realmManager.saveImageData(object: scObject, data: imageData)
        }
    }
}
