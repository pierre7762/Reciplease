//
//  RecipeDetailManager.swift
//  Reciplease
//
//  Created by Pierre on 29/12/2021.
//

import Foundation

enum FavoriteStatus {
    case favorite, notFavorite
}

class RecipeDetailManager {
    // MARK: - Internal
    
    // MARK: Internal properties
    var status: FavoriteStatus = .notFavorite
    var imageStatus: String {
        status == .favorite ? "heartSelected.png" : "heart.png"
    }
    
    // MARK: Internal methode
    func updateStatus() {
        status = status == .favorite ? .notFavorite : .favorite
    }
}
