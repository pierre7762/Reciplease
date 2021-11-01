//
//  ViewController.swift
//  Reciplease
//
//  Created by Pierre on 29/10/2021.
//

import UIKit

class SearchController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var list: UITextView!
    
    //MARK: variables
    var search = Search()
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        showListIngredients()
        
    }
    
    //MARK: functions
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    func showListIngredients() {
        var text = ""
        for ingredient in search.ingredientsList {
            text = "\(text) - \(ingredient)\n "
        }
        list.text = text
    }
    
    //MARK: actions
    @IBAction func addIngredient(_ sender: Any) {
        search.addIngredientInList(ingredientName: searchText)
        searchText = ""
        searchTextField.text = ""
        showListIngredients()
    }
    
    @IBAction func updateSearchText(_ sender: UITextField) {
        let text = sender.text ?? ""
        searchText = text
    }
    
    @IBAction func resetList(_ sender: Any) {
        search.resetIngredientInList()
        showListIngredients()
    }
}

