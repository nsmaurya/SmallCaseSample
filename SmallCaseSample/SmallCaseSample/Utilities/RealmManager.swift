//
//  RealmManager.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    func saveAllSCObject(scIDArray:[String]) {
        if !scIDArray.isEmpty {
            var scObjArray: [SCMainObject] = []
            for scid in scIDArray {
                let scMainObject = SCMainObject()
                scMainObject.scID = scid
                scObjArray.append(scMainObject)
            }
            self.saveAll(object: scObjArray)
        }
    }
    
    func getAllSCID() ->[SCMainObject]? {
        let allSCID: [SCMainObject]? = self.readObject(classType: SCMainObject.self)
        return allSCID
    }
    
    func getDetails(scID: String) -> SCIDDetail? {
        var scIDDetail: SCIDDetail?
        guard let details: [SCIDDetail] = self.readObject(classType: SCIDDetail.self) else {
            return scIDDetail
        }
        for detail in details {
            if detail.data?.scid == scID {
                scIDDetail = detail
                break
            }
        }
        return scIDDetail
    }
    
    func getHistoricalDetails(scID: String) -> SCIDHistoricalDetail? {
        var scIDDetail: SCIDHistoricalDetail?
        guard let details: [SCIDHistoricalDetail] = self.readObject(classType: SCIDHistoricalDetail.self) else {
            return scIDDetail
        }
        for detail in details {
            if detail.data?.scid == scID {
                scIDDetail = detail
                break
            }
        }
        return scIDDetail
    }
    
    func getHistoricalDetails(scID: String) -> SCIDDetail? {
        let predicate: NSPredicate = NSPredicate(format: "isLoggedInUserTicket == \(scID)")
        let scIDDetail: SCIDDetail? = self.readObject(classType: SCIDDetail.self, withPredicate: predicate)?.first
        return scIDDetail
    }
    
    func saveImageData(object: SCMainObject, data: Data) {
        self.update(object: object, data: data)
    }
    
    private func update(object: SCMainObject, data: Data) {
        do {
            let realm = try Realm()
            try realm.write {
                object.imageData = data
            }
        } catch {
            print("Error: Realm Update Failed!!!")
        }
    }
    
    private func readObject<T:Object>(classType:T.Type, withPredicate predicate:NSPredicate? = nil, andSorting sorting:[SortDescriptor]? = nil) -> [T]? {
        do {
            let realm = try Realm()
            var objArray:Results<T>
            if predicate != nil && sorting != nil {
                objArray = realm.objects(classType).filter(predicate!).sorted(by: sorting!)
            } else if predicate != nil {
                objArray = realm.objects(classType).filter(predicate!)
            } else if sorting != nil {
                objArray = realm.objects(classType).sorted(by: sorting!)
            } else {
                objArray = realm.objects(classType)
            }
            
            if objArray.isEmpty{
                return []
            }
            return Array(objArray)
        }
        catch{
            print("Realm: Unable to read")
        }
        return nil
    }
    
    func save(object: Object) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error: Realm Save Failed!!!")
        }
    }
    
    private func saveAll(object: [Object]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error: Realm SaveAll Failed!!!")
        }
    }
}
