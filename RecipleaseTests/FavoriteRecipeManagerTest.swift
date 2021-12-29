//
//  FavoriteRecipeManagerTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 29/12/2021.
//

import XCTest
@testable import Reciplease

class FavoriteRecipeManagerTest: XCTestCase {

    // MARK: - Properties
    let service = FavoriteRecipeManager()
    var coreDataStack: FakeCoreDataStack!
    var coreDataManager: CoreDataManager!

    // MARK: - Tests Life Cycle
    override func setUp() {
        super.setUp()
        coreDataStack = FakeCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    // MARK: - Tests
    func testConvertFavoriteListToRecipeList_WhenGiveFavorites_ThenReturnRecipes() throws {
        coreDataManager.addFavoriteRecipe(recipe: Recipe(
            name: "Recipe test",
            image: "",
            ingredientsLines: ["line1", "line2"],
            ingredients: [
                Ingredient(
                    text: "lemon",
                    quantity: 0.5,
                    measure: nil,
                    food: "fruit",
                    weight: 0.6,
                    image: "String?"
                ),
                Ingredient(
                    text: "sugar",
                    quantity: 0.5,
                    measure: "Fruit",
                    food: "fruit",
                    weight: 0.6,
                    image: "String?"
                )
            ],
            totalTime: 60,
            urlToWebPageRecipe: "https://test.test",
            calories: 100
        ))
        
        XCTAssertEqual(coreDataManager.favoriteRecipesList.count, 1)
        XCTAssertEqual(coreDataManager.favoriteRecipesList[0].name, "Recipe test")
        
        let favoriteList = coreDataManager.favoriteRecipesList
        let recipeList = service.convertFavoriteListToRecipeList(favoriteList: favoriteList)
        
        XCTAssertEqual(recipeList.count, 1)
        XCTAssertEqual(recipeList[0].name, coreDataManager.favoriteRecipesList[0].name)
    }

}
