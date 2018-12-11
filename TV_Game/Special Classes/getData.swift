//
//  getData.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-23.
//  Copyright © 2018 Xcode User. All rights reserved.
//

/* Created by Austin Peddle
 
 Used to get Highscore data using Alamofire */

import UIKit
import Alamofire

class getData: NSObject {

    // Data stored in Disctionary
    var dbData: [NSDictionary]?
    
    //URL to get data from
    let myURL = "http://kaur1699.dev.fast.sheridanc.on.ca/iOS_Final_Project/getScores.php"
    
    // Error if problems occur
    enum JSONError: String, Error {
        case NoData = "Error: No Data"
        case ConversionFailed = "Error: Conversion to JSON Failed"
    }
    
    //Method to parse data from DB Server and populate into Dictionary
    func JSONParser() {
        
        //Request data from DB using alamofire
        Alamofire.request(myURL, method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseString { (response) in
            do {
                let dataString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                
                guard let data = response.data else {
                    throw JSONError.NoData
                }
                
                //serialize data as JSON
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
