//
//  SelectLineTableViewCell.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/10/21.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit

class SelectLineTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var direction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
