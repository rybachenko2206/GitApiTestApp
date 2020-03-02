//
//  AlertManager.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    class func showServerErrorAlert(with error: ApiError, to viewController: UIViewController?, completion: (() -> Void)? = nil) {
        AlertManager
            .simpleAlert(title: error.title,
                         message: error.message,
                         controller: viewController,
                         completion: completion)
    }
    
    class func simpleAlert(title: String,
                           message: String,
                           controller: UIViewController?,
                           completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oklAction = UIAlertAction(title: NSLocalizedString("ОК", comment: ""),
                                      style: .default,
                                      handler: { action in
                                        completion?()
        })
        
        alertController.addAction(oklAction)
        controller?.present(alertController, animated: true, completion: nil)
    }
    
}
