//
//  SmallCaseIDDetail.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import RealmSwift

class SCIDDetail: Object, Decodable {
    @objc dynamic var data: SCIDData?
}

class SCIDData: Object, Decodable {
    @objc dynamic var scid: String?
    @objc dynamic var rationale: String?
    @objc dynamic var stats: SCIDStats?
}

class SCIDStats: Object, Decodable {
    @objc dynamic var indexValue: OptionalDouble?
    @objc dynamic var returns: SCIDReturns?

    enum CodingKeys: String, CodingKey {
        case indexValue
        case returns
    }
}

class SCIDReturns: Object, Decodable {
    @objc dynamic var monthly: OptionalDouble?
    @objc dynamic var yearly: OptionalDouble?
    
    enum CodingKeys: String, CodingKey {
        case monthly
        case yearly
    }
}


