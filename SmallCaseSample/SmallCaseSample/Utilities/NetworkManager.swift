//
//  NetworkManager.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import Reachability

protocol NetworkProtocol: class {
    func networkInfo(isNetworkAvailable: Bool, message: String)
}
private let _sharedInstance = NetworkManager()

class NetworkManager {
    weak var networkDelegate: NetworkProtocol?
    var reachability:Reachability!
    fileprivate init(){}
    
    static var sharedInstance: NetworkManager {
        return _sharedInstance
    }
    func initNetworkChecker() {
        //declare this property where it won't go out of scope relative to your listener
        reachability = Reachability()!
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            self.networkDelegate?.networkInfo(isNetworkAvailable: true, message: "Online: Wifi")
        case .cellular:
            self.networkDelegate?.networkInfo(isNetworkAvailable: true, message: "Online: Cellular")
        case .none:
            self.networkDelegate?.networkInfo(isNetworkAvailable: false, message: "Offline")
        }
    }
}
