//
//  CuisineType.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 23.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

struct CuisineType {
    var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init(_ jsonDictionary: [String: Any]) {
        let id = String(describing: jsonDictionary["Id"]!)
        let name = jsonDictionary["Name"] as! String
        self.init(id: id, name: name)
    }

}
