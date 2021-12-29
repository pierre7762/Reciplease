//
//  RecipeTableViewCellServiceTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 28/12/2021.
//

import XCTest
@testable import Reciplease

class RecipeTableViewCellServiceTest: XCTestCase {
    
    // MARK: - Properties
    let serviceTime = TimeFormatterService()
    let serviceString = IngredientListFormatterService()

    // MARK: - Tests
    func testReturnTime_WhenGiveTimeInSecond_ThenReturnCorrectString() throws {
        let test1 = serviceTime.returnTime(minutes: 50)
        XCTAssertEqual(test1, "⏱ 50min")
        let test2 = serviceTime.returnTime(minutes: 76)
        XCTAssertEqual(test2, "⏱ 1h16")
        let test3 = serviceTime.returnTime(minutes: 120)
        XCTAssertEqual(test3, "⏱ 2h")
        let test4 = serviceTime.returnTime(minutes: 0)
        XCTAssertEqual(test4, "⏱ unknown")
    }
    
    func testenderIngredientsListInOneString_WhenGiveRecipe_ThenReturnCorrectString() throws {
        let recipe = Recipe(
            name: "recipe test",
            image: "",
            ingredientsLines: [],
            ingredients: [
                Ingredient(text: "ingredient1", quantity: 1, measure: "gr", food: "ingredient1", weight: 20, image: ""),
                Ingredient(text: "ingredient2", quantity: 3, measure: "gr", food: "ingredient2", weight: 40, image: ""),
            ],
            totalTime: 20.0,
            urlToWebPageRecipe: "",
            favorite: false,
            recipceFromFavorite: false,
            calories: 3000.0
        )
        let result = serviceString.renderIngredientsListInOneString(recipe: recipe)
        
        XCTAssertEqual(result, "ingredient1 ingredient2 ")
    }
}
