//
//  InterestingPlace.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/10/23.
//

import Foundation
import CoreLocation
import MapKit

class Place: NSObject {
    
    let location: CLLocation
    let name: String
    let imageName: [String]
    let address: String
    let category: String
    let locationDescription: String
    let openingHours: String
    let phoneNumber: String
    let website: String
    
    init(latitude: Double, longitude: Double, name: String, imageName: [String], address: String, category: String, locationDescription: String, openingHours: String, phoneNumber: String, website: String) {
        location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
        self.imageName = imageName
        self.address = address
        self.category = category
        self.locationDescription = locationDescription
        self.openingHours = openingHours
        self.phoneNumber = phoneNumber
        self.website = website
    }
}

extension Place: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    var title: String? {
        get {
            return name
        }
    }
    
    var subtitle: String? {
        get {
            return category
        }
    }
}
