//
//  WeatherData.swift
//  Clima
//
//  Created by Dayton on 11/12/20.
//

import Foundation
        // Decodable turns the class to be able to decode
        // themself from external representation (JavaScript)
struct WeatherData:Codable {
    let name:String
    let main:Main
    let weather:[Weather]
}

struct Main:Codable  {
    let temp:Double
}

//Codable is a typealias which is something that combines multiple protocol into1
//Codable consists of decodable(unwrap) and encodable(wrap) from or to outer extension
struct Weather:Codable {
    let id:Int
}
