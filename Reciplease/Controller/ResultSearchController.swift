//
//  ResultSearchController.swift
//  Reciplease
//
//  Created by Pierre on 03/11/2021.
//

import UIKit

class ResultSearchController: UITableViewController {
    
    
    var data: [Recipe]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetail" else { return }
        guard let controller = segue.destination as? DetailController else { return }
        controller.recipe = sender as? Recipe
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = data[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell{
            cell.recipe = recipe
            cell.setupCell(recipe)
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            
            cell.textLabel?.text = recipe.name
            return cell
        }
   
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = data[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: recipe)
    }

    

}
