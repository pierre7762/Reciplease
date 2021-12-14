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
        requestService.getData(ingredients: "lemon") { result in
            switch result {
            case .success(let recipesApi) :
                let item = recipesApi.hits[0]
                let recipeTest = Recipe(
                    name: item.recipe.label,
                    image: item.recipe.image,
                    ingredientsLines: item.recipe.ingredientLines,
                    ingredients: item.recipe.ingredients,
                    totalTime: Double(item.recipe.totalTime),
                    urlToWebPageRecipe: item.recipe.url,
                    calories: item.recipe.calories
                )
                XCTAssert(recipeTest.name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
                print(recipeTest)
            case .failure(_):
                break
            }
        }
    }

    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)
        }
    }

    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)

        }
    }
    
    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RequestService(session: session)
        requestService.getData(ingredients: "lemon") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)
        }
    }

    
    func testgetNextPage_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        requestService.getNextPage(urlNextPage: "https://api.edamam.com/api/recipes/v2?q=lemon&app_key=db8126e5ad39d076ae0ec2cab2886f7c&_cont=CHcVQBtNNQphDmgVQntAEX4BYlBtAgAEQGxAAWMQY1RxAgoBUXlSUGobYwAmAQoPEjcWBGcbMFYiDQdSSmARAmtHMAdzAwcVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=f6f5d28b") { result in
            switch result {
            case .success(let recipesApi) :
                let item = recipesApi.hits[0]
                let recipeTest = Recipe(
                    name: item.recipe.label,
                    image: item.recipe.image,
                    ingredientsLines: item.recipe.ingredientLines,
                    ingredients: item.recipe.ingredients,
                    totalTime: Double(item.recipe.totalTime),
                    urlToWebPageRecipe: item.recipe.url,
                    calories: item.recipe.calories
                )
                XCTAssert(recipeTest.name == "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
                print(recipeTest)
            case .failure(_):
                break
            }
        }
    }
    
    func testgetNextPage_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        requestService.getNextPage(urlNextPage: "https://api.edamam.com/api/recipes/v2?q=lemon&app_key=db8126e5ad39d076ae0ec2cab2886f7c&_cont=CHcVQBtNNQphDmgVQntAEX4BYlBtAgAEQGxAAWMQY1RxAgoBUXlSUGobYwAmAQoPEjcWBGcbMFYiDQdSSmARAmtHMAdzAwcVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=f6f5d28b") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)
        }
    }
    
    func testgetNextPage_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RequestService(session: session)
        requestService.getNextPage(urlNextPage: "https://api.edamam.com/api/recipes/v2?q=lemon&app_key=db8126e5ad39d076ae0ec2cab2886f7c&_cont=CHcVQBtNNQphDmgVQntAEX4BYlBtAgAEQGxAAWMQY1RxAgoBUXlSUGobYwAmAQoPEjcWBGcbMFYiDQdSSmARAmtHMAdzAwcVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=f6f5d28b") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)

        }
    }
    
    func testgetNextPage_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RequestService(session: session)
        requestService.getNextPage(urlNextPage: "https://api.edamam.com/api/recipes/v2?q=lemon&app_key=db8126e5ad39d076ae0ec2cab2886f7c&_cont=CHcVQBtNNQphDmgVQntAEX4BYlBtAgAEQGxAAWMQY1RxAgoBUXlSUGobYwAmAQoPEjcWBGcbMFYiDQdSSmARAmtHMAdzAwcVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=public&app_id=f6f5d28b") { result in
            guard case .failure(let error) = result else { return }
            XCTAssertNotNil(error)
        }
    }


}
