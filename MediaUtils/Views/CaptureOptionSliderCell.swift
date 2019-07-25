//
//  CaptureOptionSliderCell.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/20.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
enum SlideTags : Int {
    case WB       = 0
    case Shutter
    case ISO
    case EV
}
protocol CaptureOptionSliderCellDelegate {
    func didSliderValueChange(sender : UISlider)
}
class CaptureOptionSliderCell: UITableViewCell {
    static let cellId = "CaptureOptionSliderCell"
    static let cellHeight: CGFloat = 70
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var minLable: UILabel!
    @IBOutlet weak var maxLable: UILabel!
    @IBOutlet weak var sliderValueLable: UILabel!
    var delegate: CaptureOptionSliderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func setDisplayValue(sliderMin: Float, sliderMax: Float, currentValue: Float) {
        
        self.slider.value.round()
        self.slider.minimumValue = sliderMin
        self.slider.maximumValue = sliderMax
        self.slider.value = currentValue
        self.slider.addTarget(self, action: #selector(didsliderValueChagne(sender:)), for: .valueChanged)

        self.minLable.text = String(Int(sliderMin))
        self.maxLable.text = String(Int(sliderMax))
        self.sliderValueLable.text = String(Int(currentValue))
    }
    
    func setSliderTag(type : String) {
        switch type {
        case "WB":
            self.tag = SlideTags.WB.rawValue
        case "shutter":
            self.tag = SlideTags.Shutter.rawValue
        case "ISO":
            self.tag = SlideTags.ISO.rawValue
        case "EV":
            self.tag = SlideTags.EV.rawValue
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didsliderValueChagne(sender: UISlider) {
        self.sliderValueLable.text = String(Int(sender.value))
        
        guard self.delegate == nil else {
            self.delegate?.didSliderValueChange(sender: sender)
            return
        }
    }
    
}
