//
//  ViewController.swift
//  Clima
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import CoreLocation
                                
class WeatherViewController: UIViewController{
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
            //get the data location once only
        locationManager.requestLocation()
        
        
        
    // text field should report back to this view controller
    // it will report whether the user start typing, stop typing, or tapping elsewhere to this viewcontroller
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }
   @IBAction func locationButtonPressed(_ sender: UIButton) {
    //trigger a re-update of  our location to get our location again
    locationManager.requestLocation()
    
   }
}

//MARK: - UITextFieldDelegate
                // UITextFieldDelegate manages the editing and validation of text in text field
extension WeatherViewController:UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchTextField.endEditing(true)
        
        //searchTextField.text is @"" by default. So it is okay to just force-unwrap it.
        print(searchTextField.text!)
    }
    
    // triggered if user pressed return key in keyboard, and asking what should we do next
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          
        searchTextField.endEditing(true)
        
        print(searchTextField.text!)
        
        return true
    }
    
    // view controller gets to decide what happens when user tries to deselect the textfield
    // preventing user to stop editing (trap user in editing mode) if some condition are not fulfilled
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        // if we have multiple textfield, then all the textfield can be the trigger for this method
        // if we don't care which textfield are triggered, then we can use the user input
        if textField.text != "" {
            
            //  letting textfield end editing,
            //  trigger textFieldDidEndEditing method
            return true
            
        } else {
            textField.placeholder = "Type something here"
            
            // not letting textfield end editing yet, keeping keyboard where it is
            // not trigger textFieldDidEndEditing method
            return false
        }
    }

    // the code will get triggered as soon as any of the textfields on the screen are done with editing
    // benefits: avoid repetitions. Example on when search button and textFieldShouldReturn method.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // before reset, use textField.text to get weather for the city before reset the textfield
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate

extension WeatherViewController:WeatherManagerDelegate{
  
                    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
           //completion handler usually do long running tasks (networking) so that it runs on the background.
           //Attemping to read or update UI from background tends to have problem.
           //DispatchQueue.main.async{} is a closure so you need to add self.
           DispatchQueue.main.async {
               self.temperatureLabel.text = weather.temperatureString
               self.conditionImageView.image = UIImage(systemName: weather.conditionName)
               self.cityLabel.text = weather.cityName
           
           }
       }
       
       func didFailWithError(error: Error) {
           print(error)
       }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            //as soon as we found the location, we tell the locationManager to stop
            //be it when we loaded our app, our they press the location button.
            //so that the didUpdateLocation method can be reactivated again using the button later.
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
