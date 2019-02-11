//
//  DialogManager.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation
import UIKit

private let _sharedInstance = DialogManager()

class DialogManager {
    
    fileprivate var alert:UIAlertController?
    fileprivate init(){
    }
    
    class var sharedInstance:DialogManager{
        return _sharedInstance
    }
    
    
    func showAlert(onViewController viewController:UIViewController, withText text:String, withMessage message:String, style:UIAlertController.Style = .alert, actions:UIAlertAction...){
        alert = UIAlertController(title: text, message: message, preferredStyle: style)
        if actions.count == 0{
            alert!.addAction(self.getAlertAction(withTitle: "OK", handler: { _ -> Void in
                self.alert!.dismiss(animated: true, completion: nil)
            }))
        }
        else{
            for action in actions{
                alert!.addAction(action)
            }
        }
        viewController.present(alert!, animated: true, completion: nil)
    }
    
    func getAlertAction(withTitle title:String, style:UIAlertAction.Style = .default, handler:((UIAlertAction)->Void)?)->UIAlertAction{
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
