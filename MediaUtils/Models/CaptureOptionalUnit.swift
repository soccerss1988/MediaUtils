//
//  CaptureOptionalUnit.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/20.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
private class Unitkeys {
    static let title            = "title"
    static let type             = "type"
    static let defultValue      = "defultValue"
    static let minValue         = "minValue"
    static let maxValue         = "maxValue"
    static let valueIndex       = "valueIndex"
}

class CaptureOptionalUnit: NSObject {
    var title : String
    var type : String
    var defultValue : Float = 0
    var minValue : Float = 0
    var maxValue : Float = 0
    var valueIndex = [Int]()
    
    init(jsonData: Dictionary<String,Any>){
        self.title = jsonData[Unitkeys.title] as! String
        self.type = jsonData[Unitkeys.type] as! String
        self.defultValue = jsonData[Unitkeys.defultValue] as! Float
        self.minValue = jsonData[Unitkeys.minValue] as! Float
        self.maxValue = jsonData[Unitkeys.maxValue] as! Float
        self.valueIndex = jsonData[Unitkeys.valueIndex] as! [Int]
    }
    
    
    static func getUnitsArray(options: Array<Dictionary<String,Any>>) -> [CaptureOptionalUnit] {
        var optionArray = [CaptureOptionalUnit]()
        for option in options {
            let optionUnit = CaptureOptionalUnit.init(jsonData: option)
            optionArray .append(optionUnit)
        }
        return optionArray
    }
    
}
