//
//  SCMainObject.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import RealmSwift

class SCMainObject: Object {
    @objc dynamic var scID: String?
    @objc dynamic var imageData: Data?
}
