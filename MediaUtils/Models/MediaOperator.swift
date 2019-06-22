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

class MediaOperator: NSObject {
    
    var photoSetting : AVCapturePhotoSettings?
    var avCaptureSession = AVCaptureSession()
    
    //get
//    var device : AVCaptureDevice? = {
//        return AVCaptureDevice.default(for: .video)
//    }()
//
//    lazy var avDeviceInput : AVCaptureDeviceInput? = {
//        if let device = self.device {
//             return try? AVCaptureDeviceInput.init(device: device)
//        }
//        return nil
//    }()
//
//    lazy var avDevcieOutput : AVCaptureOutput = {
//        let photoOutput = AVCapturePhotoOutput()
//        let photoSettings = AVCapturePhotoSettings()
//        photoOutput.photoSettingsForSceneMonitoring = photoSettings
//        self.photoSetting = photoSettings
//        photoSettings.flashMode = AVCaptureDevice.FlashMode.auto
//        return photoOutput
//    }()
//
//    var previewLayer : AVCaptureVideoPreviewLayer = {
//        let previewLayre = AVCaptureVideoPreviewLayer.init(session: MediaOperator().instance().avCaptureSession)
//        previewLayre.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        return previewLayre
//    }()
//
//    func instance() -> MediaOperator {
//
//        if let input = self.avDeviceInput {
//            self.avCaptureSession .addInput(input)
//        }
//        self.avCaptureSession .addOutput(self.avDevcieOutput)
//        return self
//    }
//
//    func startCapture() {
//        self.avCaptureSession.startRunning()
//    }
//
//    func stopCapture() {
//        self.avCaptureSession.stopRunning()
//    }
//
//    func take() {
//        let avcaptureConnection = self.avDevcieOutput.connection(with: .video)
//        avcaptureConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
//        if let currentPhotoSetting =  self.photoSetting {
//            let photoSetting = AVCapturePhotoSettings(from: currentPhotoSetting)
//            let photoOutput = self.avDevcieOutput as! AVCapturePhotoOutput
//            photoOutput.capturePhoto(with: photoSetting, delegate: self)
//        }
//    }
    
    //    var deviceOutput : AVCaptureDeviceOutput = {
    //            AVCaptureDeviceInput.init(device: self.device)
    //    }()
    //
    
    //    func getCarmera(type : AVMediaType, position : AVCaptureDevice.Position ) -> AVCaptureDevice? {
    //        if let carmera = AVCaptureDevice.default(.builtInDualCamera, for: type, position: position) {
    //            return carmera
    //        }
    //        return nil
    //    }
    
    func getDevice() {
        
    }
    
    
    
}
//extension MediaOperator : AVCapturePhotoCaptureDelegate {
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if(error != nil ) {
//            print("error= \(error?.localizedDescription)")
//        } else {
//            if let cgImage = photo.cgImageRepresentation() {
//                let image : UIImage = UIImage(cgImage: cgImage.takeUnretainedValue())
//                let imageData = image.jpegData(compressionQuality: 1)
//                let filepath = NSHomeDirectory() + "Documents/photo1.jpg"
//                try? imageData?.write(to: URL(string: filepath)!)
//            }
//        }
//    }
//}
