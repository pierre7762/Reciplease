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
        let favoriteRecip = FavoriteRecipe(context: managedObjectContext)
        favoriteRecip.name = recipe.name
        favoriteRecip.image = recipe.image
//        favoriteRecip.ingredientsList = ingredientsL as NSSet
        favoriteRecip.ingredientsLines = recipe.ingredientsLines
        favoriteRecip.totalTime = recipe.totalTime
        favoriteRecip.urlToWebPageRecipe = recipe.urlToWebPageRecipe
        
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
        
//        print("------------------------------------")
//        print(favoriteRecip)
        
        coreDataStack.saveContext()
        
//        print("This recipe is favorite now")
    }

    func deleteFavoriteRecipe(index: Int) {
        coreDataStack.mainContext.delete(favoriteRecipesList[index])
        coreDataStack.saveContext()
    }
}
