//
//  RecipeTableViewCellServiceTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 28/12/2021.
//

import XCTest
@testable import Reciplease

class TimeFormatterTest: XCTestCase {
    
    // MARK: - Properties
    let serviceTime = TimeFormatterService()

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
    

}
