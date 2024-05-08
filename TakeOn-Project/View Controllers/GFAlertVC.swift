//
//  GFAlert.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-19.
//

import UIKit

class GFAlertVC: UIViewController {
    
    @IBOutlet var container: UIView!
    @IBOutlet var titleLabel: GFTitleLabel!
    @IBOutlet var messageLabel: GFBodyLabel!
    @IBOutlet var actionButton: GFButton!
    
    var alertTitle:String?
    var message:String?
    var buttonLabel: String?

    func configure(title:String, message:String, buttonTitle:String) {
        self.alertTitle = title
        self.message = message
        self.buttonLabel = buttonTitle
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.75)
        
        titleLabel.text = alertTitle
        messageLabel.text = message
        actionButton.setTitle(buttonLabel, for: .normal)
        
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.white.cgColor
        
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        actionButton.layer.cornerRadius = 10
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
//    func configure(title: String, message: String, buttonLabel:String) {
//        self.titleLabel.text = title
//        self.messageLabel.text = message
//        self.actionButton.setTitle(buttonLabel, for: .normal)
//    }
}
