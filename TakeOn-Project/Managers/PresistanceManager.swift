//
//  PresistanceManager.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-26.
//

import Foundation
enum PresistanceActionType{
    case add,remove
}
enum PresistanceManager {
    static private let  defaults  = UserDefaults.standard
    
    enum Keys {
        static let  favourites = "favourites"
    }
    
    static func updateWith (favourite: Follower, actionType:  PresistanceActionType, completed : @escaping(GFError?)-> Void){
        retrieveFavourates { result in
            switch result {
            case.success(let favourites):
                var retrievedfavourites = favourites
                
                switch actionType {
                case .add:
                    guard !retrievedfavourites.contains(favourite) else {
                        completed(.alreadyInFavourites)
                        return
                    }
                    retrievedfavourites.append(favourite)
                case .remove:
                    retrievedfavourites.removeAll { $0.login == favourite.login }
                }
                completed(save(favourites: retrievedfavourites))
                
                
            case.failure(let error):
                completed(error)
            }
            
        }
        
        
    }
    
    static func retrieveFavourates(completed:@escaping(Result<[Follower], GFError>) -> Void){
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favourites  = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(favourites))
        }catch{
            completed(.failure(.unableToFavourite))
        }
    }
    static func save(favourites :[Follower]) -> GFError?{
        
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
}
