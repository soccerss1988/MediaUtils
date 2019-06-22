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
    
    var carmerSession = AVCaptureSession()
    var device : AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    var photoSetting : AVCapturePhotoSettings?
    
    @IBOutlet weak var photoDisplay: UIImageView!
    
    lazy var avInput: AVCaptureInput? = {
        if let device = self.device {
            return  try? AVCaptureDeviceInput.init(device: device)
        }
        return nil
    }()
    
    lazy var avOutput : AVCaptureOutput = {
        let photoOutput = AVCapturePhotoOutput()
        let photoSetting = AVCapturePhotoSettings()
        photoSetting.flashMode = AVCaptureDevice.FlashMode.auto
        photoOutput.photoSettingsForSceneMonitoring = photoSetting
        self.photoSetting = photoSetting
        return photoOutput
    }()
    
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer.init(session: self.carmerSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return previewLayer
    }()
    @IBOutlet weak var preview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let input = self.avInput {
            self.carmerSession.addInput(input as AVCaptureInput)
        }
        self.carmerSession.addOutput(self.avOutput)
        self.preview.layer.addSublayer(self.previewLayer)
    }
    
    @IBAction func start(_ sender: Any) {
        //        self.mediaOperator.startCapture()
        self.carmerSession.startRunning()
    }
    
    @IBAction func take(_ sender: Any) {
        self.take()
        
    }
    @IBAction func stop(_ sender: Any) {
        self.carmerSession.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        self.previewLayer.frame = self.preview.bounds
    }
    
    func take() {
        let avcaptureConnection = self.avOutput.connection(with: .video)
        avcaptureConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        if let currentPhotoSetting =  self.photoSetting {
            let photoSetting = AVCapturePhotoSettings(from: currentPhotoSetting)
            let photoOutput = self.avOutput as! AVCapturePhotoOutput
            photoOutput.capturePhoto(with: photoSetting, delegate: self)
        }
    }
}
extension CameraViewController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(error != nil ) {
            //            print("error= \(error?.localizedDescription)")
        } else {
            if let cgImage = photo.cgImageRepresentation() {
                let image : UIImage = UIImage(cgImage: cgImage.takeUnretainedValue())
                self.photoDisplay.image = image
                let imageData = image.jpegData(compressionQuality: 1)
                
                let filepath = NSHomeDirectory() + "Documents/photo1.jpg"
                try? imageData?.write(to: URL(string: filepath)!)
            }
        }
    }
}

