//
//  Restaurant.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 23.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import CoreLocation

struct Restaurant {
    var restaurantId: String
    var name: String
    var cuisineTypes: [CuisineType]
    var address: String?
    var postcode: String?
    var city: String?
    var ratingAverage: Float64
    var isOpen: Bool
    var openingTime: Date?
    var location: CLLocation?
    var url: String?
    var logoUrl: String?

    init(restaurantId: String, name: String, cuisineTypes: [CuisineType],
         address: String?, postcode: String?, city: String?,
         ratingAverage: Float64, isOpen: Bool, openingTime: Date?,
         location: CLLocation?,
         url: String?, logoUrl: String?) {
        self.restaurantId = restaurantId
        self.name = name
        self.cuisineTypes = cuisineTypes
        self.address = address
        self.postcode = postcode
        self.city = city
        self.ratingAverage = ratingAverage
        self.isOpen = isOpen
        self.openingTime = openingTime
        self.location = location
        self.url = url
        self.logoUrl = logoUrl
    }

    init(_ jsonDictionary: [String: Any]) {
        let formatter = ISO8601DateFormatter()
        let restaurantId = String(describing: jsonDictionary["Id"]!)
        let name = jsonDictionary["Name"] as! String
        let cuisineTypes: [CuisineType] = (jsonDictionary["CuisineTypes"] as! [Any]).compactMap { jsonObj -> CuisineType? in
            let cuisineType = CuisineType(jsonObj as! [String: Any])
            return cuisineType
        }
        let address = jsonDictionary["Address"] as? String
        let postcode = jsonDictionary["Postcode"] as? String
        let city = jsonDictionary["City"] as? String
        let ratingAverage = jsonDictionary["RatingAverage"] as? Float64 ?? 0.0
        let isOpen = jsonDictionary["IsOpenNow"] as? Bool ?? false
        var location: CLLocation?
        if let latitude = jsonDictionary["Latitude"] as? Float64, let longitude = jsonDictionary["Longitude"] as? Float64 {
            location = CLLocation(latitude: latitude, longitude: longitude)
        }

        var openingTime = Date.distantPast
        if let openingTimeAsString = jsonDictionary["OpeningTimeIso"] as? String {
            if let date = formatter.date(from: openingTimeAsString) {
                openingTime = date
            }
        }
        let url = jsonDictionary["Url"] as? String
        var logoUrl: String?
        let logoUrls = jsonDictionary["Logo"] as? [[String: String]]
        if let firstLogo = logoUrls?.first?["StandardResolutionURL"] {
            logoUrl = firstLogo
        }
        self.init(restaurantId: restaurantId,
                  name: name,
                  cuisineTypes: cuisineTypes,
                  address: address,
                  postcode: postcode,
                  city: city,
                  ratingAverage: ratingAverage,
                  isOpen: isOpen,
                  openingTime: openingTime,
                  location: location,
                  url: url,
                  logoUrl: logoUrl)
    }

    func fullAddress() -> String {
        var value: String = ""
        if let address = self.address,
            let city = self.city,
            let postcode = self.postcode {
            value = "\(address), \(city), \(postcode)"
        }
        return value
    }

    func allCuisines() -> String {
        let value: String = self.cuisineTypes.map{$0.name}.joined(separator: ", ")
        return value
    }

}
