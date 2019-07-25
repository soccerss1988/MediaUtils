//
//  CaptureOptionCell.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/20.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

class CaptureOptionCell: UITableViewCell {
    static let cellId = "CaptureOptionCell"
    static let cellHeight: CGFloat = 45
    @IBOutlet weak var Titlelab: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
