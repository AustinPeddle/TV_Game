//
//  getData.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-23.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

class getData: NSObject {

    var dbData : [NSDictionary]?
    
    let myUrl = "http://peddleau.dev.fast.sheridanc.on.ca/MyData/sqlToJson.php" as String
    
    enum JSONError : String, Error {
        case NoData = "Error: No Data"
        case ConversionFailed = "Error: conversion from Json Failed"
    }
    
    func jsonParser()
    {
        guard let endpoint = URL(string: myUrl) else {
            print("Error creating endpoint")
            return
        }

        let request = URLRequest(url: endpoint)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {

                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                self.dbData = json
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
}
