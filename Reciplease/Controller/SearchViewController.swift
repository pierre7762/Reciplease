//
//  ViewController.swift
//  Reciplease
//
//  Created by Pierre on 29/10/2021.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    //MARK: outlets
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var ingredientsTableView: UITableView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var searchButton: UIButton!
    @IBOutlet weak private var addButton: UIButton!
    @IBOutlet weak private var clearButton: UIButton!
    @IBOutlet weak private var ingredientsListStack: UIStackView!
    @IBOutlet weak private var ingredientsListView: UIView!
    
    //MARK: variables
    private let api = ApiConstant()
    private let fridgeService = FridgeService()
    private var urlToNextPage = ""
    private var recipeList: [Recipe] = []
    private let service: RequestService = RequestService()

    override func viewDidLoad() {
        super.viewDidLoad()
        fridgeService.delegate = self
        overrideUserInterfaceStyle = .light
        updateView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        showListIngredients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recipeList = []
    }
    
    //MARK: - functions
    private func updateView() {
        ingredientsTableView.backgroundView?.backgroundColor = UIColor(named: "white")
        searchButton.layer.cornerRadius = 12
        addButton.layer.cornerRadius = 12
        clearButton.layer.cornerRadius = 12
        
        ingredientsListView.layer.cornerRadius = 12
        ingredientsListView.layer.borderWidth = 3
        ingredientsListView.layer.borderColor = UIColor.darkGray.cgColor
        ingredientsListView.layer.shadowRadius = 12
        ingredientsListView.layer.shadowOpacity = 0.3
    }
    
    private func fetchRecipesFromEdamam() {
        let ingredientsInRequest = fridgeService.getIngredientStringRequest()
        service.getData(ingredients: ingredientsInRequest) { [ weak self] result in
            switch result {
            case .success(let recipesApi) :
                self?.urlToNextPage = recipesApi.links.next.href
                for item in recipesApi.hits {
                    var imageAdress = ""
                    if item.recipe.image.isEmpty {
                        imageAdress = "https://actunutrition.com/wp-content/uploads/2013/02/canstockphoto6878974.jpg"
                    } else {
                        imageAdress = item.recipe.image
                    }
                    let recipe = Recipe(
                        name: item.recipe.label,
                        image: imageAdress,
                        ingredientsLines: item.recipe.ingredientLines,
                        ingredients: item.recipe.ingredients,
                        totalTime: Double(item.recipe.totalTime),
                        urlToWebPageRecipe: item.recipe.url,
                        calories: item.recipe.calories
                        
                    )
                    self?.recipeList.append(recipe)
                }

                self?.loading(load: false)
                self?.performSegue(withIdentifier: "resultOfRecipesSearch", sender: self?.recipeList)
            case .failure(_):
                self?.showNoRecipeFoundAlert()
                break
            }
        }
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func showNoRecipeFoundAlert() {
        let alert = UIAlertController(title: "No recipe found !", message: "Please check the ingredient list.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.loading(load: false)
        }))

        self.present(alert, animated: true)
    }
    
    private func showEmptyInputTextAlert() {
        let alert = UIAlertController(title: "No ingredient!", message: "Please write ingredient name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.loading(load: false)
        }))

        self.present(alert, animated: true)
    }
    
    private func showDuplicateIngredientAlert() {
        let alert = UIAlertController(title: "Is already add !", message: "This ingredient is already add.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.loading(load: false)
        }))

        self.present(alert, animated: true)
    }
    
    private func showListIngredients() {
        ingredientsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultOfRecipesSearch" {
            if let newController = segue.destination as? ResultSearchViewController {
                if let data = sender as? [Recipe] {
                    newController.data = data
                    newController.urlToNextPage = urlToNextPage
                }
            }
        }
    }
    
    private func loading(load: Bool) {
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
        searchTextField.text = ""
        fridgeService.addIngredient(ingredient: fridgeService.searchText)
        if fridgeService.showEmptyInputTextAlert {
            showEmptyInputTextAlert()
            fridgeService.showEmptyInputTextAlert = false
            
        } else if fridgeService.showDuplicateIngredientAlert {
            showDuplicateIngredientAlert()
            fridgeService.showDuplicateIngredientAlert = false
        }
        
        fridgeService.searchText = ""
    }
    
    @IBAction func updateSearch(_ sender: UITextField) {
        fridgeService.searchText = sender.text ?? ""
       
    }
    
    @IBAction func resetList(_ sender: Any) {
        fridgeService.removeAllIngredients()
        showListIngredients()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        loading(load: true)
        fetchRecipesFromEdamam()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fridgeService.getFridgeIngredients().count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add some ingredients in the list"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return fridgeService.getFridgeIngredients().isEmpty ? 200 : 0
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "\(fridgeService.getFridgeIngredients()[indexPath.row])"

        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fridgeService.deleteIngredientAtIndex(index: indexPath.row)
        }
    }
}


extension SearchViewController: FridgeServiceDelegate {
    func didUpdateIngredientsList() {
        showListIngredients()
    }
    
    
}
