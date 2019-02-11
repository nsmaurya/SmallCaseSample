//
//  Extension.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import UIKit
import Reachability

extension UIImageView {
    func load(url: URL, index: Int) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    let mainViewModel: SMMainViewModel = SMMainViewModel()
                    mainViewModel.saveDownloadedImage(index: index, imageData: data)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadImage(url: URL, scMainObject: SCMainObject?) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    if let mainObject: SCMainObject = scMainObject {
                        let realmManager: RealmManager = RealmManager()
                        realmManager.saveImageData(object: mainObject, data: data)
                    }
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

extension Double {
    func toString() -> String {
        return String(format: "%.2f",self)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String? {
        return htmlToAttributedString?.string
    }
}
