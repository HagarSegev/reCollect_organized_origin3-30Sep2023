//
//  ApprovedPhotoData.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 28/07/2023.
//

import Foundation
import UIKit

class ApprovedPhotoData {
    let photoLocation: String
    var significanceValue: Int
    var image: UIImage

    init(photoLocation: String, significanceValue: Int, image: UIImage) {
        self.photoLocation = photoLocation
        self.significanceValue = significanceValue
        self.image = image
    }
}
