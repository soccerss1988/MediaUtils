//
//  FlashModeBar.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
enum FlashMode {
    case auto
    case off
    case on
}

protocol FlashModeBarDelegate : AnyObject {
    func didchangeFlashMode(mode : FlashMode)
}

class FlashModeBar: UIView {
    var currentMode : FlashMode = .auto
    weak var delegate : FlashModeBarDelegate?
    
    static func instanceFromNib(ownder: Any) -> FlashModeBar {
        return UINib(nibName: "FlashModeBar", bundle: nil).instantiate(withOwner: ownder, options: nil).last as! FlashModeBar
    }
    
    @IBAction func selectAutoMode(_ sender: Any) {
        self.changeFlashMode(selectMode: .auto)
    }
    @IBAction func selectOnMode(_ sender: Any) {
        self.changeFlashMode(selectMode: .on)
    }
    @IBAction func selectOFFMode(_ sender: Any) {
        self.changeFlashMode(selectMode: .off)
    }
    
    func changeFlashMode(selectMode: FlashMode) {
        self.currentMode = selectMode
        guard self.delegate == nil else {
            self.delegate?.didchangeFlashMode(mode: self.currentMode)
            return
        }
    }
}
