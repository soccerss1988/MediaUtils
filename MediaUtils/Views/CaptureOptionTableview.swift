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
    var optionalList : Array<Any>?
    
    public func newsinstace(owner: Any) -> CaptureOptionTableview {
        return UINib(nibName: "CaptureOptionTableview", bundle: nil).instantiate(withOwner: owner, options: nil).last as! CaptureOptionTableview
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview .register(UINib.init(nibName: "CaptureOptionCell", bundle: nil), forCellReuseIdentifier: CaptureOptionCell.cellId)
        
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
    
    let cell = tableview.dequeueReusableCell(withIdentifier: CaptureOptionCell.cellId, for: indexPath)
    return cell
    }
}
