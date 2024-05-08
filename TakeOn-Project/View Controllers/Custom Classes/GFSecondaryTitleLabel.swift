//
//  GFSecondaryTitleLabel.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-21.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(fontsize: CGFloat){
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontsize, weight: .medium)
        
        configure()
    }
    private func configure(){
        textColor = .secondaryLabel
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }



}
