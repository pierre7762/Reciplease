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
        get {
            let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            guard let favoritesrecipe = try? managedObjectContext.fetch(request) else { return [] }
            return favoritesrecipe
        }
        set {
            
        }
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
        favoriteRecip.ingredients = recipe.ingredients as NSObject
        favoriteRecip.ingredientsLines = recipe.ingredientsLines as NSObject
        favoriteRecip.totalTime = recipe.totalTime
        favoriteRecip.urlToWebPageRecipe = recipe.urlToWebPageRecipe
        
        print("------------------------------------")
        print(favoriteRecip)
        
        coreDataStack.saveContext()
        
        print("This recipe is favorite now")
    }

    func deleteFavoriteRecipe(index: Int) {
        coreDataStack.mainContext.delete(favoriteRecipesList[index])
        coreDataStack.saveContext()
    }
}
