//
//  Search.swift
//  Reciplease
//
//  Created by Pierre on 01/11/2021.
//

import Foundation

struct Search {
    var ingredientsList: [String] = []
    var result: [Recipe] = []
    
    mutating func addIngredientInList(ingredientName ingredient: String) {
        ingredientsList.append(ingredient)
    }
    
    mutating func resetIngredientInList() {
        ingredientsList = []
    }
    
    mutating func addRecipetInResult(recipe: Recipe) {
        result.append(recipe)
    }
}
