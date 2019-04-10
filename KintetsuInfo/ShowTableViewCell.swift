//
//  ShowTableViewCell.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/12/29.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var remain: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
