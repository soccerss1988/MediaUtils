//
//  OptionsSettingVIewController.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/28.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
protocol OptionsSettingVIewControllerDelegate {
    func didChangeSliderValue(sender: UISlider)
}
class OptionsSettingVIewController: UIViewController {

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var sliderbgView: UIView!
    @IBOutlet weak var mixLablel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var maxLabrl: UILabel!
    @IBOutlet weak var slider: UISlider!
    var optionUnit : CaptureOptionalUnit?
    var delegate : OptionsSettingVIewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateUI() {
        if let currentOption = self.optionUnit {
            //label text
            self.itemTitle.text = currentOption.title
            self.mixLablel.text = String(currentOption.minValue)
            self.maxLabrl.text = String(currentOption.maxValue)
            self.currentLabel.text = String(currentOption.defultValue)
            
            //slider
            self.slider.minimumValue = currentOption.minValue
            self.slider.maximumValue = currentOption.maxValue
            self.slider.value = currentOption.defultValue
            self.slider.addTarget(self, action: #selector(didChangeSliderValue(sender:)), for: .valueChanged)
            
        }
    }
    
    @objc func didChangeSliderValue(sender:UISlider) {
        self.currentLabel.text = String(sender.value.rounded())
        guard self.delegate == nil else  {
            self.delegate?.didChangeSliderValue(sender: sender)
            return
        }
    }
}
