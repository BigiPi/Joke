//
//  JokeSTru.swift
//  RandomJoke
//
//  Created by Павел Богданов on 10.03.2022.
//

import Foundation

struct JokeStruct: Codable {
    
    var success: Success?
    var contents: Contents?

}

struct Success: Codable {
    var total: Int?
}

struct Contents: Codable {
    var jokes: [Joke]?
}

struct Joke: Codable {
    var cacategory: String?
    var title: String?
    var joke: JokeInfo?
}

struct JokeInfo: Codable {
    var text: String?
}
