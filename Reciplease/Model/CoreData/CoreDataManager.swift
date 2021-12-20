//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Pierre on 26/11/2021.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext

    var favoriteRecipesList: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favoritesrecipe = try? managedObjectContext.fetch(request) else { return [] }
        return favoritesrecipe
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage Task Entity

    func addFavoriteRecipe(recipe: Recipe) {
        let isntAlreadySaved = isItFavoriteRecipe(urlRecipe: recipe.urlToWebPageRecipe)
        
        if !isntAlreadySaved {
            let favoriteRecip = FavoriteRecipe(context: managedObjectContext)
            favoriteRecip.name = recipe.name
            favoriteRecip.image = recipe.image
            favoriteRecip.ingredientsLines = recipe.ingredientsLines
            favoriteRecip.totalTime = recipe.totalTime
            favoriteRecip.urlToWebPageRecipe = recipe.urlToWebPageRecipe
            favoriteRecip.calories = recipe.calories
            
            for ingredient in recipe.ingredients {
                let ingr = FavoriteIngredient(context: managedObjectContext)
                ingr.favoriteRecipe = favoriteRecip
                ingr.food = ingredient.food
                ingr.image = ingredient.image
                ingr.measure = ingredient.measure ?? ""
                ingr.quantity = ingredient.quantity
                ingr.text = ingredient.text
                ingr.weight = ingredient.weight
            }
            
            coreDataStack.saveContext()
        }
    }

    func deleteFavoriteRecipe(urlRecipe: String) {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "urlToWebPageRecipe == %@", urlRecipe)
        
        guard let favoritesrecipeToDelete = try? managedObjectContext.fetch(request) else { return }
        
        if favoritesrecipeToDelete.count == 1 {
            coreDataStack.mainContext.delete(favoritesrecipeToDelete[0])
            coreDataStack.saveContext()
        }
    }
    
    func isItFavoriteRecipe(urlRecipe: String) -> Bool {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        var response = false
        request.predicate = NSPredicate(format: "urlToWebPageRecipe == %@", urlRecipe)
        guard let favoritesrecipe = try? managedObjectContext.fetch(request) else { return false }
        if favoritesrecipe.isEmpty {
            response = false
        } else if favoritesrecipe.count == 1 {
            response = true
        }
        
        return response
    }
}
