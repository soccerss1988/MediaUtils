//
//  OptionsItemsCollectionview.swift
//  MediaUtils
//
//  Created by YJ Huang on 2019/7/28.
//  Copyright © 2019 YJ Huang. All rights reserved.
//

import UIKit
protocol OptionsItemsCollectionviewDelegate {
    func didSelectOption(item:CaptureOptionalUnit)
}
class OptionsItemsCollectionview: UIViewController {

    @IBOutlet weak var itemsCollectionview: UICollectionView!
    var optionItems : Array<CaptureOptionalUnit>?
    var deleaget : OptionsItemsCollectionviewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.itemsCollectionview.delegate = self
        self.itemsCollectionview.dataSource = self
        self.itemsCollectionview.register(UINib(nibName: "OptionColCell", bundle: nil), forCellWithReuseIdentifier:OptionColCell.cellId)
        self.view.backgroundColor = .clear
        self.itemsCollectionview.backgroundColor = .clear
         
    }
}
extension OptionsItemsCollectionview : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.optionItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionColCell.cellId, for: indexPath) as! OptionColCell
        
        if let Items = self.optionItems {
            itemCell.title.text = Items[indexPath.row].title
            itemCell.status.text = String(Items[indexPath.row].defultValue)
        }
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.deleaget == nil else {
            if let items = self.optionItems {
                self.deleaget?.didSelectOption(item: items[indexPath.row])
            }
            return
        }
    }
    
    /// 設定 Collection View 距離 Super View上、下、左、下間的距離
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//    }

    ///  設定 CollectionViewCell 的寬、高
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - indexPath: _
    /// - Returns: _
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width) / 4 , height: self.view.frame.size.height)
    }

    /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 30
//    }

    /// 滑動方向為「垂直」的話即「左右」的間距(預設為重直)
    ///
    /// - Parameters:
    ///   - collectionView: _
    ///   - collectionViewLayout: _
    ///   - section: _
    /// - Returns: _
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
}
