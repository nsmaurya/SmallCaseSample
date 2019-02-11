//
//  SCIDHistoricalDetail.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import RealmSwift

class SCIDHistoricalDetail: Object, Decodable {
    @objc dynamic var data: SCIDHistoricalData?
}

class SCIDHistoricalData: Object, Decodable {
    @objc dynamic var scid: String?
    var pointList = List<SCIDHistoricalDataPoint>()
    
    private enum CodingKeys: String, CodingKey {
        case scid
        case pointList = "points"
    }
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scid = try container.decode(String.self, forKey: .scid)
        // Map your JSON Array response
        let pointValues = try container.decodeIfPresent([SCIDHistoricalDataPoint].self, forKey: .pointList) ?? [SCIDHistoricalDataPoint()]
        pointList.append(objectsIn: pointValues)
        
    }
}

class SCIDHistoricalDataPoint: Object, Decodable {
    @objc dynamic var date: String?
    @objc dynamic var index: OptionalDouble?
    
    enum CodingKeys: String, CodingKey {
        case date
        case index
    }
}

class OptionalDouble: Object, Decodable {
    private var numeric = RealmOptional<Double>()
    
    required public convenience init(from decoder: Decoder) throws {
        self.init()
        
        let singleValueContainer = try decoder.singleValueContainer()
        if singleValueContainer.decodeNil() == false {
            let value = try singleValueContainer.decode(Double.self)
            numeric = RealmOptional(value)
        }
    }
    
    var value: Double? {
        return numeric.value
    }
    
    var zeroOrValue: Double {
        return numeric.value ?? 0.0
    }
}
