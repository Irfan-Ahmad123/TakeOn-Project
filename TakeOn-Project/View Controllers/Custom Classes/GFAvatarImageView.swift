//
//  GFAvatarImageView.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-20.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetwrokManager.shared.cache
    let placeHolderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
        //        super.init(coder: coder)
        //        configure()
    }
    private func  configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
 }
    func downlaodImage(from urlString: String){
        
        let cacheKey = NSString(string: urlString )
        if let image = cache.object(forKey: cacheKey){
            self.image = image
            return
        }
         
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self ](data, response, error) in
            guard let self = self else {return}
            if error != nil {return}
            guard let response = response as? HTTPURLResponse,response.statusCode == 200 else  {return}
            guard let data = data else {return}
            guard let image  = UIImage(data: data) else {return}
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
