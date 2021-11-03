//
//  DetailController.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import UIKit

class DetailController: UIViewController {
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsQuantityTextField: UITextView!
    
    var data: Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.load(urlString: data.image)
        recipeNameLabel.text = data.label
        
    }
    



}
