//
//  RestaurantTableViewCell.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 23.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCuisine: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelAvailability: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    var restaurant: Restaurant? {
        didSet {
            if let res = restaurant {
                let text = res.name
                let address = "\(res.fullAddress())"
                let cuisine = "Cuisine: \(res.allCuisines())"
                let availability = String(format: "Available: %@", res.isOpen ? "Yes" : "No")

                self.labelName!.text = text
                self.labelAvailability!.text = availability
                if res.isOpen {
                    self.labelAvailability!.textColor = UIColor.green
                } else {
                    self.labelAvailability!.textColor = UIColor.red
                }
                self.labelCuisine!.text = cuisine
                self.labelAddress!.text = address
                self.loadLogoImage()
            } else {
                self.labelName!.text = "There's no data"
                self.labelAvailability!.text = ""
                self.labelCuisine!.text = ""
                self.labelAddress!.text = ""
                self.logoImageView.image = nil
            }
        }
    }
    
}

let imageCache = NSCache<NSString, UIImage>()

// MARK: - Custom async downloader with cache for logo cell images

extension RestaurantTableViewCell {

    private func loadLogoImage() {
        guard let logoUrl = self.restaurant?.logoUrl else {
            self.logoImageView.image = nil
            return
        }

        if let image = imageCache.object(forKey: logoUrl as NSString) {
            self.logoImageView.image = image
        }
        else {
            self.logoImageView.image = nil
            let dataTask = URLSession.shared.dataTask(with: URL(string: logoUrl)!) { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data!) {
                            imageCache.setObject(image, forKey: logoUrl as NSString)
                            self.logoImageView.image = image
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }

}
