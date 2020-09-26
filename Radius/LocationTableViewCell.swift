//
//  LocationTableViewCellTableViewCell.swift
//  Radius
//
//  Created by Yatharth Chhabra on 9/26/20.
//  Copyright © 2020 Yatharth Chhabra. All rights reserved.
//


import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
