//
//  FavoriteController.swift
//  Reciplease
//
//  Created by Pierre on 04/11/2021.
//

import UIKit

class FavoriteController: UITableViewController {
    //MARK: Outlet
    @IBOutlet var favoriteRecipeTableView: UITableView!
    
    //MARK: Variable
    private var coreDataManager: CoreDataManager?
    private var favoritList: [FavoriteRecipe]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let sceneDelegate = UIApplication.shared.delegate as? SceneDelegate else { return }
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate else { return }
        let coreDataStack = sceneDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        print(coreDataManager?.favoriteRecipesList[0].name as Any)
        print("lenght of favoriteListe : \(coreDataManager?.favoriteRecipesList.count ?? 0)")
        
        fetchDataFromCorData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let list = coreDataManager?.favoriteRecipesList else { return }
        favoritList = list
        favoriteRecipeTableView.reloadData()
    }
    
    //MARK: Function
    private func fetchDataFromCorData() {
        guard let list = coreDataManager?.favoriteRecipesList else { return }
        favoritList = list
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("favorite list lenght : \(favoritList.count)")
        return favoritList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "\(String(describing: favoritList[indexPath.row].name!))"

        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreDataManager!.deleteFavoriteRecipe(index: indexPath.row)
            fetchDataFromCorData()
            favoriteRecipeTableView.reloadData()
        }
    }


}
