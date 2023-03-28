//
//  DataManager.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/10/23.
//

import Foundation
import MapKit

class DataManager {
    
    static let shared = DataManager()
    
    var places: [Place] = []
    var filteredPlaces: [Place] = []
    let cells = ["Футбол", "Баскетбол", "Хоккей", "Теннис", "Волейбол"]
    
    private init() {}
    
    func loadPlaces() {
        
        guard let entries = loadPlist() else { fatalError("Unable to load data") }
        
        for property in entries {
            guard let name = property["Name"] as? String,
                  let latitude = property["Latitude"] as? NSNumber,
                  let longitude = property["Longitude"] as? NSNumber,
                  let images = property["Images"] as? [String],
                  let address = property["Address"] as? String,
                  let locationDescription = property["Description"] as? String,
                  let openingHours = property["OpeningHours"] as? String,
                  let phoneNumber = property["PhoneNumber"] as? String,
                  let website = property["Website"] as? String,
                  let category = property["Category"] as? String else { fatalError("Error reading data") }
            
            let place = Place(latitude: latitude.doubleValue, longitude: longitude.doubleValue, name: name, imageName: images, address: address, category: category, locationDescription: locationDescription, openingHours: openingHours, phoneNumber: phoneNumber, website: website)
            places.append(place)
        }
    }
    
    func loadPlist() -> [[String: Any]]? {
        guard let plistUrl = Bundle.main.url(forResource: "Places", withExtension: "plist"),
              let plistData = try? Data(contentsOf: plistUrl) else { return nil }
        var placedEntries: [[String: Any]]? = nil
        
        do {
            placedEntries = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]]
        } catch {
            print("error reading plist")
        }
        return placedEntries
    }
}
