//
//  FrideServiceTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 28/12/2021.
//

import XCTest
@testable import Reciplease

class FridgeServiceTest: XCTestCase {
    var fridge: FridgeService!
    
    //MARK: - Tests Life Cycle
    override func setUp() {
        super.setUp()
        fridge = FridgeService()
    }
    
    override func tearDown() {
        super.tearDown()
        fridge = nil
    }

    func testAddIngredient_WhenIngredientIsntInList_ThenNewIngredientAdded() throws {
        fridge.addIngredient(ingredient: "banana")
        
        let expectedList = ["banana"]
        let result = fridge.getFridgeIngredients()
        
        XCTAssertEqual(expectedList, result)
    }
    
    func testAddIngredient_WhenIngredientIsInList_ThenShowDuplicateIngredientAlertIsTrue() throws {
        fridge.addIngredient(ingredient: "")
        XCTAssertTrue(fridge.showEmptyInputTextAlert)
        fridge.addIngredient(ingredient: "banana")
        let fridgeSize = fridge.getFridgeIngredients().count
        
        fridge.addIngredient(ingredient: "banana")
        let fridgeSizeAfter = fridge.getFridgeIngredients().count
        
        XCTAssertEqual(fridgeSize, fridgeSizeAfter)
        XCTAssertTrue(fridge.showDuplicateIngredientAlert)
    }
    
    func testDeleteIngredient_WhenDeleteAtIndex_ThenJustIngredientIsDelete() throws {
        XCTAssertFalse(fridge.showDuplicateIngredientAlert)
        fridge.addIngredient(ingredient: "banana")
        fridge.addIngredient(ingredient: "cheese")
        let fridgeSize = fridge.getFridgeIngredients().count
        XCTAssertEqual(fridgeSize, 2)
        
        fridge.deleteIngredientAtIndex(index: 1)
        let fridgeSizeAfter = fridge.getFridgeIngredients().count
        XCTAssertEqual(fridgeSizeAfter, 1)
        
        let list = fridge.getFridgeIngredients()
        XCTAssertEqual(list[0], "banana")
        
    }
    
    func testRemoveAllIngredients_WhenIngredientCountIsTwoAndWeRemoveAll_ThenIngredientCountIsZero() throws {
        fridge.addIngredient(ingredient: "banana")
        fridge.addIngredient(ingredient: "cheese")
        let fridgeSize = fridge.getFridgeIngredients().count
        XCTAssertEqual(fridgeSize, 2)
        
        fridge.removeAllIngredients()
        let fridgeSizeAfter = fridge.getFridgeIngredients().count
        XCTAssertEqual(fridgeSizeAfter, 0)
    }

    func testGetIngredientStringRequest_WhenFridgeIngrendientCountIsTwo_ThenReturnStringWithTwoWords() throws {
        fridge.addIngredient(ingredient: "banana")
        fridge.addIngredient(ingredient: "cheese")
        let fridgeSize = fridge.getFridgeIngredients().count
        XCTAssertEqual(fridgeSize, 2)
        
        let result = fridge.getIngredientStringRequest()
        
        XCTAssertEqual(result, "banana,cheese,")
        
    }

}
