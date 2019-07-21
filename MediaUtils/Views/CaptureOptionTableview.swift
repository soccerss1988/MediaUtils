//
//  CaptureOptionTableview.swift
//  CoUtiles
//
//  Created by YJ Huang on 2019/7/20.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit

open class CaptureOptionTableview: UIView {
    @IBOutlet weak var tableview: UITableView!
    var optionalList : Array<CaptureOptionalUnit>?
    var isOpen : Bool = false
    
    public static func newsinstace(owner: Any) -> CaptureOptionTableview {
        return UINib(nibName: "CaptureOptionTableview", bundle: nil).instantiate(withOwner: owner, options: nil).last as! CaptureOptionTableview
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.tableview.layer.cornerRadius = 15
        self.tableview.clipsToBounds = true
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview .register(UINib.init(nibName: "CaptureOptionCell", bundle: nil), forCellReuseIdentifier: CaptureOptionCell.cellId)
        self.tableview .register(UINib.init(nibName: "CaptureOptionSliderCell", bundle: nil), forCellReuseIdentifier: CaptureOptionSliderCell.cellId)
        
        
    }

}
extension CaptureOptionTableview : UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionalList?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let optionalUnit = self.optionalList![indexPath.row]
        if optionalUnit.type == "main" {
            if let cell  = tableview.dequeueReusableCell(withIdentifier: CaptureOptionCell.cellId, for: indexPath) as? CaptureOptionCell {
                cell.Titlelab.text = optionalUnit.title
                return cell
            }
        } else {
            if let  cell  = tableview.dequeueReusableCell(withIdentifier: CaptureOptionSliderCell.cellId, for: indexPath) as? CaptureOptionSliderCell {
                cell.setDisplayValue(sliderMin: optionalUnit.minValue, sliderMax: optionalUnit.maxValue, currentValue: optionalUnit.defultValue)
                cell.backgroundColor = .lightGray
                return cell
            }
        }
        return UITableViewCell()
    }
}
