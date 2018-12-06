//
//  Alertable.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-22.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import SpriteKit

protocol Alertable { }
extension Alertable where Self: SKScene {
    
    func showAlert() {
        
        let alertController = UIAlertController(title: "Opps", message: "You hit a wall", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        view?.window?.rootViewController?.present(alertController, animated: true)
}
    
}
