//
//  myDataTableViewCell.swift
//  Assignment2and3
//
//  Created by Xcode User on 2018-11-23.
//  Copyright © 2018 Xcode User. All rights reserved.
//

/*  Created By Austin Peddle
 
 Used for table view cell in TV App*/

import UIKit

class myDataTableViewCell: UITableViewCell {
    
    @IBOutlet var score : UILabel!
    @IBOutlet var username : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
