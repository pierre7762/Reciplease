//
//  RecipeTableViewCellService.swift
//  Reciplease
//
//  Created by Pierre on 28/12/2021.
//

import Foundation

class RecipeTableViewCellService {
    func returnTime(minutes: Int) -> String {
        let (h, m) = minutesToHoursMinutes(seconds: minutes)

        if h == 0 && m > 0 {
            return "⏱ \(m)min"
        } else if m == 0 && h > 0 {
            return "⏱ \(h)h"
        } else if h == 0 && m == 0 {
            return "⏱ unknown"
        }
        
        return "⏱ \(h)h\(m)"
    }
    
    func renderIngredientsListInOneString(recipe: Recipe) -> String{
        var theString = ""
        
        for ingredient in recipe.ingredients {
            theString = "\(theString)\(ingredient.food) "
        }
        
        return theString
    }
    
    private func minutesToHoursMinutes (seconds : Int) -> (Int, Int) {
       (seconds / 60, (seconds % 60))
    }

}
