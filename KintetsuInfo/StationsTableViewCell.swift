//
//  StationsTableViewCell.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/10/11.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit

class StationsTableViewCell: UITableViewCell {

    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var grade: CBAutoScrollLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        grade.labelSpacing = 50;                          // 開始と終了の間間隔
        grade.pauseInterval = 3;                          // スクロール前の一時停止時間
        grade.scrollSpeed = 50.0;                         // スクロール速度
        grade.fadeLength = 20.0;                          // 左端と右端のフェードの長さ
        grade.font = UIFont.systemFont(ofSize: 15.0)      // フォント設定
        direction.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
