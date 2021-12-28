//
//  FridgeService.swift
//  Reciplease
//
//  Created by Pierre on 28/12/2021.
//

import Foundation

class FridgeService {
    
    var showDuplicateIngredientAlert = false
    var showEmptyInputTextAlert = false
    var searchText: String = ""
    private var fridgeIntegrients: [String] = []
    
    func getFridgeIngredients() -> [String] {
        fridgeIntegrients
    }
    
    func addIngredient(ingredient: String) {
        if ingredient.count > 0 {
            let ingredientIsAlreadyInTheList = isItAlreadyInTheList(ingredient: ingredient)
            
            switch ingredientIsAlreadyInTheList {
                case .ok:
                    fridgeIntegrients.append(ingredient)
                case .alreadyInTheList:
                    showDuplicateIngredientAlert = true
            }
        } else {
            showEmptyInputTextAlert = true
        }
    }
    
    func deleteIngredientAtIndex(index: Int) {
        fridgeIntegrients.remove(at: index)
    }
    
    func removeAllIngredients() {
        fridgeIntegrients = []
    }
    
    func getIngredientStringRequest() -> String {
        var text = ""
        for ingredient in fridgeIntegrients {
            text = "\(text)\(ingredient),"
        }
        return text
    }
    
    private func isItAlreadyInTheList (ingredient: String) -> checkIngredient {
        for ingredientInList in fridgeIntegrients {
            if ingredient == ingredientInList { return .alreadyInTheList }
        }
        return .ok
    }
    
   
}

enum checkIngredient {
    case ok, alreadyInTheList
}
