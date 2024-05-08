//
//  ErrorMessage.swift
//  TakeOn-Project
//
//  Created by Rashdan Natiq on 2024-02-20.
//

import Foundation

enum GFError: String, Error{
    
    case invalidUsername = "This username creates an invalid request. Please try again later."
    case unbleToComplete = "Unable to complete your request.Please check your internet connection."
    case invalidResponse = "Invalid response from the server.Please try again."
    case invalidData = "The data received from the server was invalid.Please try again."
    case unableToFavourite = "There was an erro favourating this user. Please try again. "
    case alreadyInFavourites = "You 've already favourited this user.You must REALLY like them!"
}
