//
//  GFFollwerItemVC.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-23.
//

import UIKit

class GFFollowItemVC: GFItemInfoVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionBtnTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
