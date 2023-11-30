//
//  DataSet.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 28/07/2023.
//

import Foundation
import Photos
import UIKit

class DataSet {
    static let shared = DataSet()
    static let SignificanceLevelDidChangeNotification = Notification.Name("SignificanceLevelDidChange")

    private init() {}

    public var shownPhotos: [String] = []
    public var approvedPhotosData = [String: ApprovedPhotoData]()
    public var name: String = ""
    public var age: Int = 0
    public var gender: String = ""
    public var country: String = ""
    

    func addApprovedPhotoData(photoLocation: String, significanceValue: Int, image: UIImage) {
        approvedPhotosData[photoLocation] = ApprovedPhotoData(photoLocation: photoLocation, significanceValue: significanceValue, image: image)
    }
    
    
    func increaseSignificanceValue(for photoLocation: String, completion: (Int) -> Void) {
        var significanceValue = approvedPhotosData[photoLocation]?.significanceValue ?? 0
        significanceValue = (significanceValue) % 4 + 1
        approvedPhotosData[photoLocation]?.significanceValue = significanceValue
        completion(significanceValue)
        FirebaseManager.shared.updateSignificanceRating(for: photoLocation, newRating: significanceValue){ error in
            if let error = error {
                print("Failed to upload photo: \(error.localizedDescription)")
            } else {
                print("Photo uploaded successfully!")
            }
        }
            
        NotificationCenter.default.post(name: DataSet.SignificanceLevelDidChangeNotification, object: nil)

    }
    
    func numberOfApprovedPhotos() -> Int {
        return approvedPhotosData.count
    }
    
    // for debugging:
    
//    func randomImagesForDataset(numOfPhotos: Int) {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        
//        // Add a predicate to exclude screenshots
//        fetchOptions.predicate = NSPredicate(format: "mediaType == %d && !(mediaSubtype & %d != 0)", PHAssetMediaType.image.rawValue, PHAssetMediaSubtype.photoScreenshot.rawValue)
//        
//        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//
//        let count = allPhotos.count
//        if count > 0 {
//            for _ in 0..<numOfPhotos {
//                let randomIndex = Int(arc4random_uniform(UInt32(count)))
//                let randomPhoto = allPhotos.object(at: randomIndex)
//                let photoLocation = randomPhoto.localIdentifier
//                addApprovedPhotoData(photoLocation: photoLocation, significanceValue: 1)
//            }
//        }
//    }
}


