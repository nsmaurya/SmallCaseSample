//
//  Globals.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Device
struct Device {
    struct ScreenSize {
        static let width         = UIScreen.main.bounds.size.width
        static let height        = UIScreen.main.bounds.size.height
    }
}

struct SmallCaseURLs {
    static let smallCase: String = "https://api-dev.smallcase.com/smallcases/"
    static let singleSmallCase: String = "\(smallCase)smallcase?scid="
    static let singleSmallCaseHistorical: String = "\(smallCase)historical?scid="
    static let smallCaseImage: String = "https://assets.smallcase.com/images/smallcases/187/"
}

public func imageUrl(scid: String) -> URL? {
    let imageURL: String = "\(SmallCaseURLs.smallCaseImage)\(scid).png"
    return URL(string: imageURL)
}
