//
//  FavoriteRecipeManager.swift
//  Reciplease
//
//  Created by Pierre on 29/12/2021.
//

import Foundation


class FavoriteRecipeManager {
    func convertFavoriteListToRecipeList (favoriteList:[FavoriteRecipe]) -> [Recipe] {
        var recipeList: [Recipe] = []
        for favorite in favoriteList {
            let recipe = convertFavoriteToRecipe(favorite: favorite)
            recipeList.append(recipe)
        }
        
        return recipeList
    }
    
    private func convertFavoriteToRecipe (favorite: FavoriteRecipe) -> Recipe {
        let ingredients = favorite.ingredientsList?.allObjects as? [FavoriteIngredient] ?? []
        let recipeIngredients = ingredients.map {
            Ingredient(
                text: $0.text ?? "",
                quantity: $0.quantity,
                measure: $0.measure,
                food: $0.food ?? "",
                weight: $0.weight,
                image: $0.image
            )
        }
        
        
        let recipe = Recipe(
            name: favorite.name,
            image: favorite.image,
            ingredientsLines: favorite.ingredientsLines,
            ingredients: recipeIngredients,
            totalTime: favorite.totalTime ,
            urlToWebPageRecipe: favorite.urlToWebPageRecipe,
            favorite: false,
            recipceFromFavorite: false,
            calories: favorite.calories
        )
        
        
        return recipe
    }
}
