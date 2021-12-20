//
//  Search.swift
//  Reciplease
//
//  Created by Pierre on 02/11/2021.
//

import Foundation

// MARK: - RecipesAPi
struct RecipesAPi: Codable {
    let from, to, count: Int
    let links: RecipesAPiLinks
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: RecipeAPI
    let links: HitLinks

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinks: Codable {
    let linksSelf: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Codable {
    let href: String
    let title: Title
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
}

// MARK: - Recipe
struct RecipeAPI: Codable {
    let uri: String
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, totalWeight: Double
    let totalTime: Int
}

enum Unit: String, Codable {
    case empty = "%"
    case g = "g"
    case kcal = "kcal"
    case mg = "mg"
    case µg = "µg"
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight
        case image
    }
}

// MARK: - Total
struct Total: Codable {
    let label: String
    let quantity: Double
    let unit: Unit
}

// MARK: - RecipesAPiLinks
struct RecipesAPiLinks: Codable {
    let next: Next
}
