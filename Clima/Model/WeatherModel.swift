//
//  WeatherModel.swift
//  Clima
//
//  Created by Dayton on 11/12/20.
//

import Foundation


struct WeatherModel{
    // it is called stored properties
    let  conditionId:Int
    let  cityName:String
    let  temperature:Double
    
    
    // it is called computed properties
    
    //computed properties has to be a var. The value changes based on the computations.
    // You must provide an output that would be set as the value of this property.
    var  conditionName:String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
            

        }
    }
    
    var temperatureString:String{
        return String(format: "%.1f", temperature)
    }
    
    
}
