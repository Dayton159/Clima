//
//  WeatherManager.swift
//  Clima
//
//  Created by Dayton on 11/12/20.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)
    func didFailWithError(error:Error)
    
}

struct WeatherManager {
    
     let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=356cdbbe244ee433f9b8adb88298544f&units=metric"
        //https are secure url instead of http
    
    
    //setting it to be an optional protocol so that whatever class or struct that needs the weather data
    //needs to adopt this protocol and set the delegate to themself and we can call
    // the delegate and update the weather.
    //so our WeatherManager struct is reusable(not need to change the code) to any class
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Create a URL
        
            //initializing url from string commonly may have chances of typo and thus make the func fails.
            //So the URL struct are optional based and you need to do an optional binding to safe opened it.
            // if as long url doesn't fail (not nil &succeed) pass it to url constant and then execute other networking steps.
        
        if let url = URL(string: urlString) {
        
        //2. Create URLSession
        
        let session = URLSession(configuration: .default) // create object something like browser which perform networking
            
        //3. Give the session a task
            
            
        //when retrieving the data task from internet is done, it call this func.
        // the task performs handle method and pass its data,response and error to the method
        let task = session.dataTask(with: url) { (data, response, error) in
            //was there any error in networking process
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
                return //exit out of handle method, and dont continue.
            }
            
            //check the data that it got back
            if let safeData = data{
                    //optional binding it once again because the parseJSON func may be able to return nil
                if let weather =  self.parseJSON(safeData){
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        
    //4. Start the task
        
    task.resume() // newly init task begin in suspended state, call resume to start the task
    }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        // an object that can decode JSON
        let decoder = JSONDecoder()
        
        do{  // do blocks have a thing with things with try
            //try marks an object that can throws an error  (if something go wrong)
                    //by adding .self, it converts the WeatherData into a datatype instead of object.
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            //the path is gotten from the api where you use the chrome extension to copy the property path
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weatherModel
        }catch{  //if it does throws the error then catch the error
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
 
}

extension WeatherManager{
    func fetchWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
}
