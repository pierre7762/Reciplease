//
//  ViewController.swift
//  Reciplease
//
//  Created by Pierre on 29/10/2021.
//

import UIKit
import Alamofire

class SearchController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var listIngredientsTextView: UITextView!
    
    
    
    //MARK: variables
    var search = Search()
    let api = ApiConstant()
    var searchText = ""
    var readyToShow = false
    private let baseUrl: String = ""
    var ingredientsInRequest: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        showListIngredients()
    }
    
    //MARK: functions
    func fetchRecipesFromEdamam() {
        AF.request(self.api.edamamBaseUrl, method: .get, parameters: [
            "q": self.ingredientsInRequest,
            "app_id": self.api.edamamId,
            "app_key": self.api.edamamKey,
            "from": "0", "to": "6"
        ]).responseDecodable(of: RecipesAPi.self) { response in
            DispatchQueue.main.async { [self] in
                guard let recipesList = response.value?.hits else {
                    print("erreur")
                    return
                }
                self.search.result = []
                for item in recipesList {
                    let recipe = Recipe(label: item.recipe.label, image: item.recipe.image, ingredientsLines: item.recipe.ingredientLines, ingredients: item.recipe.ingredients, totalTime: Double(item.recipe.totalTime))
                    self.search.addRecipetInResult(recipe: recipe)
                }
                self.performSegue(withIdentifier: "resultOfRecipesSearch", sender: self.search.result)
            }
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func showListIngredients() {
        print(search.ingredientsList)
        var text = ""
        for ingredient in search.ingredientsList {
            text = "\(text) - \(ingredient)\n "
            print(text)
        }
        listIngredientsTextView.text = text
    }
    
    func updateIngredientsInRequest() {
        var text = ""
        for ingredient in search.ingredientsList {
            text = "\(text)\(ingredient),\n "
        }
        ingredientsInRequest = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultOfRecipesSearch" {
            if let newController = segue.destination as? ResultSearchController {
                if let data = sender as? [Recipe] {
                    newController.data = data
                }
            }
        }
    }
    
    //MARK: actions
    @IBAction func addIngredient(_ sender: Any) {
        search.addIngredientInList(ingredientName: searchText)
        searchText = ""
        searchTextField.text = ""
        showListIngredients()
    }
    @IBAction func updateSearch(_ sender: UITextField) {
        let text = sender.text ?? ""
        searchText = text
    }
    
    @IBAction func resetList(_ sender: Any) {
        search.resetIngredientInList()
        showListIngredients()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        updateIngredientsInRequest()
        fetchRecipesFromEdamam()
    }
}

