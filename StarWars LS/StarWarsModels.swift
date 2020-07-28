//
//  StarWarsModels.swift
//  StarWars LS
//
//  Created by Akib Shahjahan on 2020-07-28.
//  Copyright © 2020 Akib Shahjahan. All rights reserved.
//

/// A Star Wars Character
struct Person: Codable {
    var name: String
    var birth_year: String
    var height: String
    var mass: String
    var hair_color: String
    var eye_color: String
    var films: Array<String>
}

/// Star Wars Characters Page
struct People: Codable {
    var count: Int
    var next: String?
    var results: Array<Person>
}

// A Star Wars Film
struct Film: Codable {
    var title: String
    var opening_crawl: String
}
