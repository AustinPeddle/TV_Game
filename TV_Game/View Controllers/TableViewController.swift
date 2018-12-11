//
//  TableViewController.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-23.
//  Copyright © 2018 Xcode User. All rights reserved.
//

/*
 Created by Austin Peddle
 
 Loads Highscore data into table
 */

import UIKit

class TableViewController: UITableViewController {

    //Creates GetData object
    let GetData = getData()
    
    //Sets timer to refresh table
    var timer : Timer!
    
    //Connects to Table
    @IBOutlet var myTable : UITableView!
    
    //Creates View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Sets timer for refresh
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true)
        
        //Populates data
        GetData.JSONParser()
        
    }
    
    //Refreshes table when data is available from DB
    @objc func refreshTable(){
    
        //check if data is there
        if GetData.dbData != nil {
            if (GetData.dbData?.count)! > 0 {
                
                //Once data is available sort, reload, and invalidate timer
                GetData.dbData = GetData.dbData?.sorted { ($0.value(forKey: "Highscore") as! String ?? "") > ($1.value(forKey: "Highscore") as! String ?? "") }
                self.tableView.reloadData()
                self.timer.invalidate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //Populate number of sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Check if data is available to populate table
        if GetData.dbData != nil {
            return (GetData.dbData?.count)!
        }
        return 0
    }
    
    //Populate table with data taken from DB
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get tablecell to populate data with
        let tableCell : myDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? myDataTableViewCell ?? myDataTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        
        //Get row that is being populated and associated data
        let row = indexPath.row
        let rowData = GetData.dbData![row] as NSDictionary
        
        //Update table labels with row data
        tableCell.username.text = rowData["Username"] as? String
        tableCell.score.text = rowData["Highscore"] as? String
        
        //return updated cell
        return tableCell
    }

}

