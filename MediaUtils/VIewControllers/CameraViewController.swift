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
import CoUtiles


public class CameraViewController: UIViewController {
    
    @IBOutlet weak var photoDisplay: UIImageView!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var flashModeView: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var switchCameraBurron: UIButton!
    @IBOutlet weak var optionSettingContainer: UIView!
    @IBOutlet weak var optionItemContainer: UIView!

    var mediaOperator = MediaOperator().instance()
    var isFlashBarOpen  = false
    var currentSelectOptionItem : CaptureOptionalUnit?

    lazy var optionSettingVC : OptionsSettingVIewController = {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsSettingVC") as! OptionsSettingVIewController
    }()

    lazy var optionItemsCollectView : OptionsItemsCollectionview = {
        let viwe = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OptionsItemsColectVC") as! OptionsItemsCollectionview
        return viwe
    }()

    lazy var flashModeBar : FlashModeBar = {
        let flashModeBar = FlashModeBar.instanceFromNib(ownder: self)
        flashModeBar.delegate = self
        return flashModeBar
    }()
    
    lazy var cellConfig : [CaptureOptionalUnit]? = {
        
        if let jsonPath = Bundle.main.path(forResource: "CaptureCellConfig", ofType: "json") {
            if let data = try? NSData(contentsOfFile: jsonPath) as Data {
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                    if let array = jsonData["optionCellConfig"] as? Array<Dictionary<String,Any>> {
                        return CaptureOptionalUnit.getUnitsArray(options: array)
                    }
                }
            }
        }
        return  nil
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.preview.layer.insertSublayer(self.mediaOperator.previewLayer, at: 0)
        self.captureButtonStyle()
        self.mediaOperator.delegate = self
        self.flashModeView.isHidden = true
        self.settingOptionItems()
        self.settingCustomCarmera()
    }
    
    func captureButtonStyle() {
        self.captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        self.captureButton.layer.borderWidth = 2
        self.captureButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        self.mediaOperator.startCapture()
    }
    
    override public func viewDidLayoutSubviews() {
        self.mediaOperator.previewLayer.frame = self.preview.bounds
        self.optionSettingVC.view.frame = self.optionSettingContainer.bounds
        self.optionItemsCollectView.view.frame = self.optionItemContainer.bounds
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        self.mediaOperator.stopCapture()
    }
    
    @IBAction func take(_ sender: Any) {
        self.mediaOperator.take()
    }
    
    @IBAction func switchInputCarmera(_ sender: Any) {
        //前後相機切換
        self.mediaOperator.swithInputCamera()
    }
    
    
    @IBAction func flashMode(_ sender: Any) {
        
        if self.isFlashBarOpen == true {
            self.closeFlashModeBar()
        } else {
            self.openFlashModeBar()
        }
    }
    
    func openFlashModeBar() {
        
        self.flashModeBar.frame = self.flashModeView.bounds
        self.flashModeView.addSubview(self.flashModeBar)
        
        let originWidth = (self.switchCameraBurron.frame.midX - self.flashButton.frame.maxX - 50)
        flashModeviewStyle(hidden: false, alpha: 0, width: 0)
        UIView .animate(withDuration: 0.2) {
            self.isFlashBarOpen = true
            self.flashModeviewStyle(hidden: false, alpha: 1, width: originWidth)
        }
    }
    
    func closeFlashModeBar() {
        UIView .animate(withDuration: 0.2) {
            self.isFlashBarOpen = false
            self.flashModeviewStyle(hidden: true, alpha: 0, width: 0)
        }
    }
    
    func flashModeviewStyle(hidden: Bool, alpha: CGFloat, width: CGFloat) {
        self.flashModeView.frame.size.width = width
        self.flashModeView.alpha = alpha
        self.flashModeView.isHidden = hidden
    }
    
    func settingOptionItems() {
    
    self.addChild(self.optionSettingVC)
    self.addblurEffect(superView: self.optionSettingContainer, style: .dark)
    self.optionSettingContainer.addSubview(self.optionSettingVC.view)
    self.optionSettingContainer.layer.cornerRadius = 10
    self.optionSettingContainer.clipsToBounds =  true
    self.optionSettingContainer.isHidden = true
    self.optionSettingVC.delegate = self

    self.addblurEffect(superView: self.optionItemContainer, style: .dark)
    self.addChild(self.optionItemsCollectView)
    self.optionItemContainer.addSubview(self.optionItemsCollectView.view)
    self.optionItemsCollectView.optionItems = self.cellConfig
    self.optionItemsCollectView.itemsCollectionview.reloadData()
    self.optionItemsCollectView.deleaget = self

    }
    
    func settingCustomCarmera() {
        if let customItems = self.cellConfig {
            
            for items in customItems {
                switch items.title {
                case "ISO":
                    self.mediaOperator.captureSetting.iso = items.defultValue
                case "S":
                    self.mediaOperator.captureSetting.shutt = CMTimeMake(value: Int64(items.defultValue), timescale: 1000000)
                case "EV":
                    self.mediaOperator.captureSetting.ev = items.defultValue
                case "WB":
                    self.mediaOperator.captureSetting.k = items.defultValue
                default:
                    break
                }
            }
        }
    }
    
    //    func test() {
    //
    //        self.mediaOperator.currentInputDevice?.lensAperture
    //        try? self.mediaOperator.currentInputDevice?.lockForConfiguration()
    //
    //        //expisure 曝光
    //        self.mediaOperator.currentInputDevice?.exposureMode = .autoExpose
    //        self.mediaOperator.currentInputDevice?.exposureMode = .continuousAutoExposure
    //        self.mediaOperator.currentInputDevice?.exposureMode = .locked
    //
    //        //ISO 快門+iso
    //        print(self.mediaOperator.currentInputDevice?.activeFormat.minISO as Any)//22
    //        print(self.mediaOperator.currentInputDevice?.activeFormat.maxISO as Any)//880
    //        print(self.mediaOperator.currentInputDevice?.activeFormat.minExposureDuration as Any)//CMTime(value: 20, timescale: 1000000
    //        print(self.mediaOperator.currentInputDevice?.activeFormat.maxExposureDuration as Any)//CMTime(value: 333333, timescale: 1000000
    //        self.mediaOperator.currentInputDevice?.setExposureModeCustom(duration: self.mediaOperator.currentInputDevice?.activeFormat.maxExposureDuration ?? CMTimeMake(value: 0, timescale: 0), iso: 500, completionHandler: { (cmtime) in
    //
    //        })
    //
    //
    //        //對焦
    //        self.mediaOperator.currentInputDevice?.focusMode = .autoFocus
    //        self.mediaOperator.currentInputDevice?.focusMode = .continuousAutoFocus
    ////        self.mediaOperator.currentInputDevice?.focusMode = .locked
    //
    //        //EV
    //        print(self.mediaOperator.currentInputDevice?.minExposureTargetBias ?? 0)// in EV units -8
    //        print(self.mediaOperator.currentInputDevice?.maxExposureTargetBias ?? 0)// in EV units +8
    //                self.mediaOperator.currentInputDevice?.setExposureTargetBias(self.mediaOperator.currentInputDevice?.minExposureTargetBias ?? 0, completionHandler: { (cmtime) in
    //
    //                })
    //
    //
    //        //shuuter
    //
    //
    //        //WB
    ////        self.mediaOperator.currentInputDevice?.whiteBalanceMode = .autoWhiteBalance
    ////        self.mediaOperator.currentInputDevice?.whiteBalanceMode = .continuousAutoWhiteBalance
    ////        self.mediaOperator.currentInputDevice?.whiteBalanceMode = .locked
    //
    //        self.mediaOperator.currentInputDevice?.unlockForConfiguration()
    //
    //    }
    
    
    
}

extension UIViewController {
    
    func addblurEffect(superView: UIView, style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = superView.bounds
        superView.addSubview(blurView)
    }
}

extension CameraViewController : FlashModeBarDelegate, OptionsItemsCollectionviewDelegate, OptionsSettingVIewControllerDelegate {
    
    func didchangeFlashMode(mode: FlashMode) {
        
        switch mode {
        case .auto:
            self.flashButton.setBackgroundImage(UIImage(named:"flashAuto"), for: .normal)
            self.mediaOperator.modifyFlashMode(flashMode: .auto)
        case .on:
            self.flashButton.setBackgroundImage(UIImage(named:"flashOn"), for: .normal)
            self.mediaOperator.modifyFlashMode(flashMode: .on)
        case .off:
            self.flashButton.setBackgroundImage(UIImage(named:"flashOff"), for: .normal)
            self.mediaOperator.modifyFlashMode(flashMode: .off)
        }
        self.closeFlashModeBar()
    }
    
    func didSelectOption(item: CaptureOptionalUnit) {
        //open
        self.optionSettingContainer.isHidden = false
        self.optionSettingVC.optionUnit = item
        self.optionSettingVC.updateUI()
        self.currentSelectOptionItem = item
    }
    
    func didChangeSliderValue(sender: UISlider) {
        print("change Value = \(sender.value)")
        self.optionSettingContainer.isHidden = true
        
        //update collection itmen 上的數字
        if let needUpdateItem = self.cellConfig?.filter({$0.title == self.currentSelectOptionItem?.title}) {
            print(needUpdateItem.first?.title ?? "")
            needUpdateItem.first?.defultValue = sender.value.rounded()
            self.optionItemsCollectView.itemsCollectionview.reloadData()
            switch needUpdateItem.first?.title ?? "" {
            case "ISO":
                self.mediaOperator.captureSetting.iso = needUpdateItem.first?.defultValue ?? 0
            case "S":
                let int64Value = Int64(needUpdateItem.first?.defultValue ?? 0)
                self.mediaOperator.captureSetting.shutt =  CMTimeMake(value: int64Value, timescale: 1000000)
            case "EV":
                self.mediaOperator.captureSetting.ev = needUpdateItem.first?.defultValue ?? 0
            case "WB":
                self.mediaOperator.captureSetting.k = needUpdateItem.first?.defultValue ?? 0
            default:
                break
            }
        }
        self.setCustomCameraExposuer()
    }
    
    //    func setCustomCameraExposuer(iso: Float, shutter : CMTime, ev: Float, wb: AVCaptureDevice.WhiteBalanceGains) {
    func setCustomCameraExposuer() {
        do {
            try self.mediaOperator.currentInputDevice?.lockForConfiguration()
            //change cutoms value here
            let shutter = self.mediaOperator.captureSetting.shutt
            let iso = self.mediaOperator.captureSetting.iso
            let ev = self.mediaOperator.captureSetting.ev
            let k = self.mediaOperator.captureSetting.k
            
            //setting exposure
            self.mediaOperator.currentInputDevice?.setExposureModeCustom(duration:shutter , iso: iso, completionHandler: nil)
            
            //setting ev
            self.mediaOperator.currentInputDevice?.setExposureTargetBias(ev, completionHandler: nil)
            
            //setting K
            let temperatureAndTintValues = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(temperature: k, tint: 0)
            if let deviceGains = self.mediaOperator.currentInputDevice?.deviceWhiteBalanceGains(for: temperatureAndTintValues) {
                self.mediaOperator.currentInputDevice?.setWhiteBalanceModeLocked(with: deviceGains, completionHandler: nil)
            }
            
            self.mediaOperator.currentInputDevice?.unlockForConfiguration()
        } catch {
            print("lock faild!! can not change value")
        }
        
    }
    
}

extension CameraViewController : MediaOperatorDelegate {
   public func receveCapturePhoto(image: UIImage) {
        self.photoDisplay.image = image
    }
}


