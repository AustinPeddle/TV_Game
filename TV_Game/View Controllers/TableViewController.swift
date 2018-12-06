//
//  TableViewController.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-23.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let GetData = getData()
    var timer : Timer!
    
    @IBOutlet var myTable : UITableView!
    
    @IBAction func goBack(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        print("back?")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true);
        
        GetData.jsonParser()
        
    }
    
    @objc func refreshTable(){
        
        if (GetData.dbData?.count)! > 0
        {
            GetData.dbData = GetData.dbData?.sorted { ($0.value(forKey: "SCORE") as! String ?? "") > ($1.value(forKey: "SCORE") as! String ?? "") }
            self.myTable.reloadData()
            self.timer.invalidate()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if GetData.dbData != nil
        {
            return (GetData.dbData?.count)!
        }
        else
        {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell : myDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? myDataTableViewCell ?? myDataTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        
        let row = indexPath.row
        let rowData = (GetData.dbData?[row])! as NSDictionary
        tableCell.score.text = rowData["SCORE"] as? String
        
        return tableCell
    }

}