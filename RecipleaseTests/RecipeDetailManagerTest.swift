//
//  RecipeDetailManagerTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 29/12/2021.
//

import XCTest
@testable import Reciplease

class RecipeDetailManagerTest: XCTestCase {
    // MARK: - Properties
    var service = RecipeDetailManager()

    // MARK: - Tests
    func testUpdateStatus_WhenModifieStatus_ThenImageStatusChange() throws {
        XCTAssertEqual(service.status, .notFavorite)
        XCTAssertEqual(service.imageStatus, "heart.png")
        
        service.updateStatus()
        
        XCTAssertEqual(service.status, .favorite)
        XCTAssertEqual(service.imageStatus, "heartSelected.png")
        
        service.updateStatus()
        
        XCTAssertEqual(service.status, .notFavorite)
        XCTAssertEqual(service.imageStatus, "heart.png")
    }

}
