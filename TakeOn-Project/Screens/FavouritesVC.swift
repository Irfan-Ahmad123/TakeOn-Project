//
//  FavouritesVC.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-19.
//

import UIKit

class FavouritesVC: UIViewController {
    
    let tableView = UITableView()
    var favourites : [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewCOntroller()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    func getFavourites(){
        PresistanceManager.retrieveFavourates { [weak self]result in
            guard let self = self else {return}
            
            switch result {
            case .success(let favourites):
                if favourites.isEmpty{
                    showEmptySateView(with: "No favourites\nAdd one on the follower screen.", in: self.view)
                } else {self.favourites = favourites}
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonLabel: "OK")
            }
        }
    }
    func configureViewCOntroller(){
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
        
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }
}
extension FavouritesVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID) as! FavouriteCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowersListVC()
        destVC.userName = favourite.login
        destVC.title = favourite.login
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let favourite = favourites[indexPath.row]
        favourites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PresistanceManager.updateWith(favourite: favourite, actionType: .remove) { [weak self] error in
            guard let self = self else {return}
            
            guard let error = error else {return}
            
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonLabel: "OK")
        }
    }
}
