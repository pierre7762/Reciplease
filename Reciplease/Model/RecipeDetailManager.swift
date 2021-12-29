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
        if status == .favorite {
            return "heartSelected.png"
        }
        return "heart.png"
    }
    
    // MARK: Internal methode
    func updateStatus() {
        if status == .favorite {
            status = .notFavorite
        } else {
            status = .favorite
        }
    }
}
