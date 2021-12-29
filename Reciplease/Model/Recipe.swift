//
//  Recipe.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import Foundation

struct Recipe {
    // MARK: - Internal
    
    // MARK: Properties
    var name: String!
    var image: String!
    var ingredientsLines: [String]!
    var ingredients: [Ingredient]
    var totalTime: Double
    var urlToWebPageRecipe: String!
    var favorite: Bool = false
    var recipceFromFavorite: Bool = false
    var calories: Double
}
