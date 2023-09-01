//
//  UIViewController+.swift
//  FleaMarketApp
//
//  Created by koala panda on 2023/09/01.
//

import UIKit

extension UIViewController {
    func collectionViewProductslayout(collectionView: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        // デバイスの幅を取得
        let screenWidth = UIScreen.main.bounds.width
        // セルの幅を計算
        let cellWidth = (screenWidth - (3 * layout.minimumLineSpacing) - layout.sectionInset.left - layout.sectionInset.right) / 3
        // 高さもcellWidthと同じにして、正方形のセルにする
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.collectionViewLayout = layout
    }
}
