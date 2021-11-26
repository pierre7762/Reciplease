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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    //MARK: variables
//    var search = Search()
    let api = ApiConstant()
    var searchText = ""
    var readyToShow = false
    private let baseUrl: String = ""
    
    
    var ingredientsInRequest: String = ""
    var recipeList: [Recipe] = []
    var ingredientList: [String] = []
    var loading: Bool = false
    
    private let service: RequestService = RequestService()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        showListIngredients()
    }
    
    //MARK: functions
    func updateView() {
        listIngredientsTextView.layer.shadowColor = UIColor.black.cgColor
        listIngredientsTextView.layer.shadowOpacity = 1
        listIngredientsTextView.layer.shadowOffset = .zero
        listIngredientsTextView.layer.shadowRadius = 10
    }
    
    func fetchRecipesFromEdamam() {
        service.getData(ingredients: self.ingredientsInRequest, fromIndex: 0, toIndex: 2) { result in
            switch result {
            case .success(let recipesApi) :
                for item in recipesApi.hits {
                    let recipe = Recipe(
                        name: item.recipe.label,
                        image: item.recipe.image,
                        ingredientsLines: item.recipe.ingredientLines,
                        ingredients: item.recipe.ingredients,
                        totalTime: Double(item.recipe.totalTime),
                        urlToWebPageRecipe: item.recipe.url
                    )
                    self.recipeList.append(recipe)
                }

                self.loading(load: false)
                self.performSegue(withIdentifier: "resultOfRecipesSearch", sender: self.recipeList)
            case .failure(_):
                break
            }
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "No recipe found !", message: "Please, check the list of ingredients.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.loading(load: false)
        }
    ))

        self.present(alert, animated: true)
    }
    
    func showListIngredients() {
        print(ingredientList)
        var text = ""
        for ingredient in ingredientList {
            text = "\(text)\n - \(ingredient)"
            print(text)
        }
        listIngredientsTextView.text = text
    }
    
    func updateIngredientsInRequest() {
        var text = ""
        for ingredient in ingredientList {
            text = "\(text)\(ingredient),"
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
    
    func loading(load: Bool) {
        if load {
            searchButton.layer.isHidden = true
            activityIndicator.layer.isHidden = false
        } else {
            searchButton.layer.isHidden = false
            activityIndicator.layer.isHidden = true
        }
        
    }
    
    //MARK: actions
    @IBAction func addIngredient(_ sender: Any) {
//        search.addIngredientInList(ingredientName: searchText)
        ingredientList.append(searchText)
        searchText = ""
        searchTextField.text = ""
        showListIngredients()
    }
    @IBAction func updateSearch(_ sender: UITextField) {
        let text = sender.text ?? ""
        searchText = text
    }
    
    @IBAction func resetList(_ sender: Any) {
//        search.resetIngredientInList()
        ingredientList.removeAll()
        showListIngredients()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        loading(load: true)
        updateIngredientsInRequest()
        fetchRecipesFromEdamam()
    }
}

