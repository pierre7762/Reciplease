//
//  Search.swift
//  Reciplease
//
//  Created by Pierre on 01/11/2021.
//

import Foundation

struct Search {
    var ingredientsList: [String] = []
    
    mutating func addIngredientInList(ingredientName ingredient: String) {
        ingredientsList.append(ingredient)
    }
    
    mutating func resetIngredientInList() {
        ingredientsList = []
    }
}
