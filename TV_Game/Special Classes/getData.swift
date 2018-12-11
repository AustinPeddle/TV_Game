//
//  getData.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-23.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit
import Alamofire

class getData: NSObject {

    var dbData: [NSDictionary]?
    let myURL = "http://kaur1699.dev.fast.sheridanc.on.ca/iOS_Final_Project/getScores.php"
    
    enum JSONError: String, Error {
        case NoData = "Error: No Data"
        case ConversionFailed = "Error: Conversion to JSON Failed"
    }
    
    func JSONParser() {
        
        Alamofire.request(myURL, method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseString { (response) in
            do {
                let dataString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                
                guard let data = response.data else {
                    throw JSONError.NoData
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                    throw JSONError.ConversionFailed
                }
                
                self.dbData = json
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
}
