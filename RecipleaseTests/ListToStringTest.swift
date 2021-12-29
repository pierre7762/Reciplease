//
//  ListToStringTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 29/12/2021.
//

import XCTest
@testable import Reciplease

class ListToStringTest: XCTestCase {
    // MARK: - Properties
    let serviceTime = TimeFormatterService()
    let serviceString = IngredientListFormatterService()

    // MARK: - Tests
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
