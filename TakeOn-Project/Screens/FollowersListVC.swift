//
//  FollowersListVC.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-19.
//

import UIKit

class FollowersListVC: UIViewController {
    
    enum Section{
        case main
    }
    var userName: String!
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var filteredFollowers: [Follower] = []
    var isSearching = false
    
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower >!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureViewController()
        getFollowers(username: userName, page: page)
        configureDataSource()
        configureSearchController()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
   
    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
//        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addBtnTapped(){
        showLoadingScreen()
        NetwrokManager.shared.getUserInfo(for: userName) {[weak self] result  in
            guard let self = self else {return}
            self.dismissLoadingScreen()
            
            switch result{
            case .success(let user):
                
                let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PresistanceManager.updateWith(favourite: favourite, actionType: .add) {[weak self ] error in
                    guard let self = self else {return}
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favourated this user ❤️", buttonLabel: "Hooray!")
                        return
                    }
                    self.presentGFAlertOnMainThread(title:  "Something went wrong", message: error.rawValue, buttonLabel: "OK")
                }
                
            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonLabel: "OK")
            }
        }
    }
    
    func getFollowers(username: String, page: Int){
        showLoadingScreen()
        NetwrokManager.shared.getFollowers(for: userName, page: page) {[weak self] result in
            
            guard let self = self else {return}
            self.dismissLoadingScreen()
            switch result{
            case.success(let followers):
                if followers.count < 100 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty{
                    let message = "This user doesn't have any followers.Go follow them."
                    DispatchQueue.main.async {                        showEmptySateView(with: message, in: self.view)
                    }
                }
                self.updateData(on: self.followers)
            //                print(followers)
            case.failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonLabel: "OK")
            }
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers : [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower >()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
extension FollowersListVC: UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsety = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsety > contentHeight - height{
            guard hasMoreFollowers else {
                return
            }
            page += 1
            getFollowers(username: userName, page: page)
        }
//        print("offsetY \(offsety)")
//        print("ContentHeight\(contentHeight)")
//        print("Height\(height)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers:followers
        let follower = activeArray[indexPath.item]
        
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
       
    }
    
}
extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {return}
        isSearching = true
        filteredFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
    
}
protocol FollowerListVCDelegate: class {
    func didRequestFollowers(for username: String)
}
extension FollowersListVC: FollowerListVCDelegate{
    
    func didRequestFollowers(for username: String) {
        self.userName = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }

}
