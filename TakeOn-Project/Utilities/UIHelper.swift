//
//  UIHelper.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-20.
//

import UIKit

struct UIHelper {
    
    static func createThreeColumnFlowLayout(in view : UIView)->UICollectionViewFlowLayout{
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding*2) - (minimumItemSpacing*2)
        let itemWidth = availableWidth/3
        let flowlayout = UICollectionViewFlowLayout ()
        flowlayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowlayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        return flowlayout
    }
}
