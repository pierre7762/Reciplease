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
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchStack: UIStackView!
    @IBOutlet weak var ingredientsListStack: UIStackView!
    @IBOutlet weak var ingredientsListView: UIView!
    
    
    
    //MARK: variables
    private let api = ApiConstant()
    private var searchText = ""
    private var urlToNextPage = ""
    private var readyToShow = false
    private let baseUrl: String = ""
    
    private var ingredientsInRequest: String = ""
    private var recipeList: [Recipe] = []
    private var ingredientList: [String] = []
    private var loading: Bool = false
    
    private let service: RequestService = RequestService()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK: functions
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
//        service.getData(ingredients: self.ingredientsInRequest) { [ weak self] result in
        service.getData(ingredients: "chicken") { [ weak self] result in
            switch result {
            case .success(let recipesApi) :
                self?.urlToNextPage = recipesApi.links.next.href
                for item in recipesApi.hits {
                    let recipe = Recipe(
                        name: item.recipe.label,
                        image: item.recipe.image,
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
                self?.showAlert()
                break
            }
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "No recipe found !", message: "Please check the ingredient list.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.loading(load: false)
        }))

        self.present(alert, animated: true)
    }
    
    private func showListIngredients() {
        ingredientsTableView.reloadData()
    }
    
    private func updateIngredientsInRequest() {
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
        ingredientList.removeAll()
        showListIngredients()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        loading(load: true)
        updateIngredientsInRequest()
        fetchRecipesFromEdamam()
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellTest = tableView.dequeueReusableCell(withIdentifier: 'standardCell')
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "\(ingredientList[indexPath.row])"

        cell.contentConfiguration = content
        
        return cell
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
        return ingredientList.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientList.remove(at: indexPath.row)
            updateIngredientsInRequest()
            ingredientsTableView.reloadData()
        }
    }
    
}
