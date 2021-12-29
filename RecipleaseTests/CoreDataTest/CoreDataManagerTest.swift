//
//  CoreDataManagerTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 14/12/2021.
//

@testable import Reciplease
import XCTest

class CoreDataManagerTest: XCTestCase {
    // MARK: - Properties
    var coreDataStack: FakeCoreDataStack!
    var coreDataManager: CoreDataManager!

    // MARK: - Tests Life Cycle
    override func setUp() {
        super.setUp()
        coreDataStack = FakeCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }

    // MARK: - Tests
    func testAddFavoriteRecipeInCoreDataEmpty_WhenDataSave_ThenShouldReturnOneObject() {
        XCTAssertEqual(coreDataManager.favoriteRecipesList.count, 0)
        
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
    }
    
    func testDeleteFavoriteRecipeInCoreData_WhenDataSave_ThenShouldReturnOneObject() {
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
                )
            ],
            totalTime: 60,
            urlToWebPageRecipe: "https://test.test",
            calories: 100
        ))
        XCTAssertEqual(coreDataManager.favoriteRecipesList.count, 1)
        
        coreDataManager.deleteFavoriteRecipe(urlRecipe: "https://test.test")
        
        XCTAssertEqual(coreDataManager.favoriteRecipesList.count, 0)
    }
    
    func testisItFavoriteRecipeInCoreData_WhenWeWouldUpdateFavoriteIcon_ThenShouldReturnTrue() {
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
                )
            ],
            totalTime: 60,
            urlToWebPageRecipe: "https://test.test",
            calories: 100
        ))
        XCTAssertEqual(coreDataManager.favoriteRecipesList.count, 1)
        
        let expected = true
        let response = coreDataManager.isItFavoriteRecipe(urlRecipe: "https://test.test")
        
        XCTAssertEqual(expected, response)
    }
}
