//
//  GFRepoItemVC.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-23.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionBtnTapped() {
        delegate.didTapGithubProfile(for: user)
    }
}
