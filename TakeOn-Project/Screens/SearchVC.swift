//
//  SearchVC.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-19.
//

import UIKit

class SearchVC: UIViewController {
    
    var  isUserNameEntered:Bool{return !enterUserName.text!.isEmpty
    }
    @IBOutlet var getFollowers: GFButton!
    @IBOutlet var enterUserName: GFTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        dismissKeyboardTapGesture()
        enterUserName.delegate = self
        getFollowers.addTarget(self, action: #selector(pushToFollowersListVC), for: .touchUpInside)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "displayErrorSegue" {
//            if let gfAlertVC = segue.destination as? GFAlertVC {
//                // Configure GFAlertVC if needed
////                gfAlertVC.alertTitle = "Empty Username"
////                gfAlertVC.message = "Please enter a username. We need to know who to look for 🧐"
////                gfAlertVC.buttonLabel = "OK"
//            }
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
  
    func dismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing) )
        view.addGestureRecognizer(tap)
    }
    @objc func pushToFollowersListVC() {
//        guard isUserNameEntered else {
////            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 🧐", buttonLabel: "OK")
//            performSegue(withIdentifier: "displayErrorSegue", sender: nil)
//            return
//
//        !enterUserName.text!.isEmpty
    
        guard isUserNameEntered else {
            self.presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 🧐", buttonLabel: "OK")
            return 
        }
        let followersListVC = FollowersListVC()
        followersListVC.userName = enterUserName.text
        followersListVC.title = enterUserName.text
        navigationController?.pushViewController(followersListVC, animated: true)
    }
}
extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushToFollowersListVC()
        return true
    }
}
