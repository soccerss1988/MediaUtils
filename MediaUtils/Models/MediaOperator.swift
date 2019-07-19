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
    
    var delegate : MediaOperatorDelegate?
    
    //Get devices cameras
    lazy var devices : [AVCaptureDevice] = {
        let device  = AVCaptureDevice.DiscoverySession(deviceTypes:
            [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],mediaType: .video, position: .unspecified)
        return device.devices
    }()
    
    lazy var fontCamera : AVCaptureDevice? = {
        return self.getCamera(position: .front) ?? nil
    }()
    
    lazy var backCamera : AVCaptureDevice? = {
        return self.getCamera(position: .back) ?? nil
    }()
    
    var currentInputDevice : AVCaptureDevice?
    
    //Instance Session
    var captureSession = AVCaptureSession()
    
    //Setting Input defult from backCamera
    lazy var captureDefultInput : AVCaptureInput? = {
        if let frontCamera  = self.backCamera {
            self.currentInputDevice = frontCamera
            return try? AVCaptureDeviceInput.init(device: frontCamera)
        }
        return nil
    }()
    
    var currentInput : AVCaptureInput?
    
    //Setting Output
    lazy var avOutput : AVCaptureOutput = {
        let photoOutput = AVCapturePhotoOutput()
        let photoSetting = AVCapturePhotoSettings()
        photoSetting.flashMode = self.currentFalshMode
        photoOutput.photoSettingsForSceneMonitoring = photoSetting
        self.photoSetting = photoSetting
        return photoOutput
    }()
    
    var currentFalshMode : AVCaptureDevice.FlashMode  = .off
    
    //PhotoSetting
    var photoSetting : AVCapturePhotoSettings?
    
    //setting displayPreviewlayr
    lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return previewLayer
    }()
    
//    MARK: -func
    func instance() -> MediaOperator {
        
        if let input = self.captureDefultInput {
            self.currentInput = input
            self.captureSession.addInput(input as AVCaptureInput)
        }
        self.captureSession.addOutput(self.avOutput)
        return self
    }
    
    func startCapture() {
        self.captureSession.startRunning()
    }
    
    func stopCapture() {
        self.captureSession.stopRunning()
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
    
    func getCamera(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let cameras = self.devices.compactMap{$0}
        for carmer in cameras {
            if carmer.position == position {
                return carmer
            }
        }
        return nil
    }
    
    func swithInputCamera() {
        if let currentDevice = self.currentInputDevice {
            
            switch currentDevice.position {
            case .front:
                // turn to back camera
                if let input = self.currentInput , let bcakCamera = self.backCamera {
                    self.captureSession.removeInput(input)
                    if let newInput = try? AVCaptureDeviceInput(device: bcakCamera) {
                        if self.captureSession.canAddInput(newInput) {
                            self.currentInputDevice = bcakCamera
                            self.currentInput = newInput
                            self.captureSession.addInput(newInput)
                            
                        }
                    }
                }
                
                
            case .back:
                
                // turn to back camera
                if let input = self.currentInput , let fontCamera = self.fontCamera {
                    self.captureSession.removeInput(input)
                    
                    if let newInput = try? AVCaptureDeviceInput(device: fontCamera) {
                        if self.captureSession.canAddInput(newInput) {
                            self.currentInputDevice = fontCamera
                            self.currentInput = newInput
                            self.captureSession.addInput(newInput)
                        }
                    }
                }
                
            default:
                break;
            }
        }
    }
    
    func modifyFlashMode(flashMode: AVCaptureDevice.FlashMode ) {
        self.photoSetting?.flashMode = flashMode
    }
}

extension MediaOperator : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if(error != nil ) {
            print("error= \(String(error?.localizedDescription ?? ""))")
        } else {
            if let cgImage : Unmanaged<CGImage> = photo.cgImageRepresentation() {
                let image =  UIImage(cgImage: cgImage.takeUnretainedValue())
                if let orientaitionImage = self.deviecOrientation(image: image) {
                    //                                UIImageWriteToSavedPhotosAlbum(orientaitionImage,nil,nil,nil)
                    guard self.delegate == nil else {
                        self.delegate?.receveCapturePhoto(image: orientaitionImage)
                        return
                    }
                }
            }
        }
    }
    
    
    func deviecOrientation(image: UIImage) -> UIImage? {
        var rotateImage : UIImage?
        let pi = 180.00
        switch UIDevice.current.orientation {
        case .faceUp, .faceDown:
            rotateImage = image
        case .landscapeRight:
            rotateImage = image.rotate(angle: -pi )
            
        case .landscapeLeft:
//            rotateImage = image.rotate(angle: pi * 2 )
            rotateImage = image
            
        case .portrait:
            rotateImage = image.rotate(angle: pi/2)
        case .portraitUpsideDown:
            rotateImage = image.rotate(angle: -(pi/2))
            
        case .unknown:
            return nil
        @unknown default:
            return nil
        }
        return rotateImage ?? nil
    }
}





//
// func rotateImage(_ image: UIImage, withAngle angle: Double) -> UIImage? {
//    if angle.truncatingRemainder(dividingBy: 360) == 0 { return image }
//    let imageRect = CGRect(origin: .zero, size: image.size)
//    let radian = CGFloat(angle / 180 * Double.pi)
//    let rotatedTransform = CGAffineTransform.identity.rotated(by: radian)
//    var rotatedRect = imageRect.applying(rotatedTransform)
//    rotatedRect.origin.x = 0
//    rotatedRect.origin.y = 0
//    UIGraphicsBeginImageContext(rotatedRect.size)
//    guard let context = UIGraphicsGetCurrentContext() else { return nil }
//    context.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
//    context.rotate(by: radian)
//    context.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
//    image.draw(at: .zero)
//    let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return rotatedImage
//}
    
extension UIImage {
    
    func rotate(angle: Double) -> UIImage? {
        if angle.truncatingRemainder(dividingBy: 360) == 0 {
            return self
        }
        
        let imageRect = CGRect(origin: .zero, size: self.size)
        let radian = CGFloat(angle / 180 * Double.pi)
        let rotatedTransform = CGAffineTransform.identity.rotated(by: radian)
        var rotatedRect = imageRect.applying(rotatedTransform)
        rotatedRect.origin.x = 0
        rotatedRect.origin.y = 0
        UIGraphicsBeginImageContext(rotatedRect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
        context.rotate(by: radian)
        context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
        self.draw(at: .zero)
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}

