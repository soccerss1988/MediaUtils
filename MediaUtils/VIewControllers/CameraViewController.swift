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
    @IBOutlet weak var captureButton: UIButton!
    var mediaOperator = MediaOperator().instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preview.layer.insertSublayer(self.mediaOperator.previewLayer, at: 0)
        self.captureButtonStyle()
        self.mediaOperator.delegate = self
        test()
    }
    
    func captureButtonStyle() {
        self.captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        self.captureButton.layer.borderWidth = 2
        self.captureButton.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mediaOperator.startCapture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.mediaOperator.stopCapture()
    }
    
    @IBAction func take(_ sender: Any) {
        self.mediaOperator.take()
    }
    
    @IBAction func switchInputCarmera(_ sender: Any) {
        //前後相機切換
        self.mediaOperator.swithInputCamera()
    }
    
    @IBAction func CarmeraSettingOptions(_ sender: Any) {
        
    }
    
    @IBAction func flashMode(_ sender: Any) {
        
    }
    
    override func viewDidLayoutSubviews() {
        self.mediaOperator.previewLayer.frame = self.preview.bounds
    }
    
    func test() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
            [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],mediaType: .video, position: .unspecified)
        print(discoverySession.devices)
        if let backCam = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            print(backCam)
        }
    }
}

extension CameraViewController : MediaOperatorDelegate {
    func receveCapturePhoto(image: UIImage) {
        self.photoDisplay.image = image
    }
}
