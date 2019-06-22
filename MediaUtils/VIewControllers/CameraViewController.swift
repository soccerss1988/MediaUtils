//
//  ViewController.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/6/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO

class CameraViewController: UIViewController {
    
    @IBOutlet weak var photoDisplay: UIImageView!
    @IBOutlet weak var preview: UIView!
    var mediaOperator = MediaOperator().instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preview.layer.addSublayer(self.mediaOperator.previewLayer)
    }
    
    @IBAction func start(_ sender: Any) {
        self.mediaOperator.startCapture()
    }
    
    @IBAction func take(_ sender: Any) {
        self.mediaOperator.take()
    }
    
    @IBAction func stop(_ sender: Any) {
        self.mediaOperator.stopCapture()
    }
    
    override func viewDidLayoutSubviews() {
        self.mediaOperator.previewLayer.frame = self.preview.bounds
    }
}

