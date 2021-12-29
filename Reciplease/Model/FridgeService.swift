//
//  FridgeService.swift
//  Reciplease
//
//  Created by Pierre on 28/12/2021.
//

import Foundation

enum checkIngredient {
    case ok, alreadyInTheList
}

protocol FridgeServiceDelegate: AnyObject {
    func didUpdateIngredientsList()
}

class FridgeService {
    
    weak var delegate: FridgeServiceDelegate?
    
    // MARK: - Internal
    
    // MARK: Properties
    var showDuplicateIngredientAlert = false
    var showEmptyInputTextAlert = false
    var searchText: String = ""
    
    // MARK: Functions
    func getFridgeIngredients() -> [String] {
        fridgeIngredients
    }
    
    func addIngredient(ingredient: String) {
        if ingredient.count > 0 {
            let ingredientIsAlreadyInTheList = isItAlreadyInTheList(ingredient: ingredient)
            
            switch ingredientIsAlreadyInTheList {
                case .ok:
                    fridgeIngredients.append(ingredient)
                case .alreadyInTheList:
                    showDuplicateIngredientAlert = true
            }
        } else {
            showEmptyInputTextAlert = true
        }
    }
    
    func deleteIngredientAtIndex(index: Int) {
        fridgeIngredients.remove(at: index)
    }
    
    func removeAllIngredients() {
        fridgeIngredients = []
    }
    
    func getIngredientStringRequest() -> String {
        var text = ""
        for ingredient in fridgeIngredients {
            text = "\(text)\(ingredient),"
        }
        return text
    }
    
    // MARK: - Private
    
    // MARK: Properties
    private var fridgeIngredients: [String] = [] {
        didSet {
            delegate?.didUpdateIngredientsList()
        }
    }
    
    // MARK: Functions
    private func isItAlreadyInTheList (ingredient: String) -> checkIngredient {
        for ingredientInList in fridgeIngredients {
            if ingredient == ingredientInList { return .alreadyInTheList }
        }
        return .ok
    }
    
   
}


