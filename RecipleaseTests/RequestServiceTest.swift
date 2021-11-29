//
//  RequestServiceTest.swift
//  RecipleaseTests
//
//  Created by Pierre on 26/11/2021.
//

import XCTest
@testable import Reciplease

class RequestServiceTest: XCTestCase {

    func testGetData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon", fromIndex: 0, toIndex: 1) { result in
            switch result {
            case .success(let recipesApi) :
                let item = recipesApi.hits[0]
                let recipeTest = Recipe(
                    name: item.recipe.label,
                    image: item.recipe.image,
                    ingredientsLines: item.recipe.ingredientLines,
                    ingredients: item.recipe.ingredients,
                    totalTime: Double(item.recipe.totalTime),
                    urlToWebPageRecipe: item.recipe.url
                )
                XCTAssert(recipeTest.name == "Lemon Sorbet")
                print(recipeTest)
            case .failure(_):
                break
            }
        }
    }

    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon", fromIndex: 0, toIndex: 1) { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)
        }
    }

    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon", fromIndex: 0, toIndex: 1) { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)

        }
    }
    
    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon", fromIndex: 0, toIndex: 1) { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)
        }
    }



}
