//
//  MediaOperator.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/6/17.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
protocol MediaOperatorDelegate {
    func receveCapturePhoto(image: UIImage)
}
class MediaOperator: NSObject {
    
    var carmerSession = AVCaptureSession()
    var device : AVCaptureDevice? = AVCaptureDevice.default(for: .video)
    var photoSetting : AVCapturePhotoSettings?
    var displayImage : UIImage?
    var delegate : MediaOperatorDelegate?
    
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
    
    func instance() -> MediaOperator {
        
        if let input = self.avInput {
            self.carmerSession.addInput(input as AVCaptureInput)
        }
        self.carmerSession.addOutput(self.avOutput)
        return self
    }
    
    func startCapture() {
        self.carmerSession.startRunning()
    }
    
    func stopCapture() {
        self.carmerSession.stopRunning()
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
extension MediaOperator : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(error != nil ) {
            //            print("error= \(error?.localizedDescription)")
        } else {
            if let cgImage = photo.cgImageRepresentation() {
                let image : UIImage = UIImage(cgImage: cgImage.takeUnretainedValue())
                let imageData = image.jpegData(compressionQuality: 1)
                let filepath = NSHomeDirectory() + "/Documents/photo1.jpg"
                do {
                   try imageData?.write(to: URL(fileURLWithPath: filepath))
                    print("photo path  = \(filepath)")
                    
                    guard self.delegate == nil else {
                        self.delegate?.receveCapturePhoto(image: image)
                        return
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
