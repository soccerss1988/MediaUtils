//
//  CaptureOptionSliderCell.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/20.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

class CaptureOptionSliderCell: UITableViewCell {
    static let cellId = "CaptureOptionSliderCell"
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var minLable: UILabel!
    @IBOutlet weak var maxLable: UILabel!
    @IBOutlet weak var sliderValueLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func setDisplayValue(sliderMin: Float, sliderMax: Float, currentValue: Float) {
        self.slider.minimumValue = sliderMin
//        self.minLable.text = "\(sliderMin)"
        
        self.slider.maximumValue = sliderMax
//        self.maxLable.text = "\(sliderMax)"
        
        self.slider.value = currentValue
//        self.sliderValueLable.text = "\(sliderMax)"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
