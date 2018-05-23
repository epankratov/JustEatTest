//
//  DefaultTestParameters.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

struct DefaultTestParameters {
    static let defaultAPIServer: String = "https://public.je-apis.com/"
    static let defaultRestaurantsEndpoint: String = "restaurants"
    static let defaultHeaders: [String: String] = ["Accept-Tenant": "uk", "Accept-Language": "en-GB", "Authorization": "Basic VGVjaFRlc3Q6bkQ2NGxXVnZreDVw", "Host": "public.je-apis.com"]
}
