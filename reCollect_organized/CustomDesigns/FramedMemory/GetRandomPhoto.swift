//
//  GetRandomPhoto.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 27/06/2023.
//

import Photos
import UIKit

func getRandomPhoto(completion: @escaping (UIImage? , String?) -> ()) {
    // Request authorization
    PHPhotoLibrary.requestAuthorization { (status) in
        switch status {
        case .authorized:
            // Get all photos in the user's photo library
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            // Add a predicate to exclude screenshots
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d && !(mediaSubtype & %d != 0)", PHAssetMediaType.image.rawValue, PHAssetMediaSubtype.photoScreenshot.rawValue)
            
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            // Check there is at least one photo
            guard assets.count > 0 else {
                completion(nil, nil)
                return
            }
            // Check if there are any more photos to show
            if assets.count > DataSet.shared.shownPhotos.count {
                var randomIndex: Int
                var asset: PHAsset
                
                repeat {
                    randomIndex = Int.random(in: 0..<assets.count)
                    asset = assets.object(at: randomIndex)
                } while DataSet.shared.shownPhotos.contains(asset.localIdentifier)
                
                repeat {
                    randomIndex = Int.random(in: 0..<assets.count)
                    asset = assets.object(at: randomIndex)
                } while DataSet.shared.shownPhotos.contains(asset.localIdentifier)
                
//                DataSet.shared.shownPhotos.append(asset.localIdentifier)
                
                let manager = PHImageManager.default()
                
                let options = PHImageRequestOptions()
                options.isSynchronous = false
                options.deliveryMode = .highQualityFormat
                options.isNetworkAccessAllowed = true
                
                manager.requestImageData(for: asset, options: options) { data, _, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        completion(image, asset.localIdentifier)
                    }
                }
            }

        case .denied, .restricted:
            // Handle denied or restricted access
            completion(nil, nil)
        case .notDetermined:
            // Handle case where user has not yet made a choice
            completion(nil, nil)
        case .limited:
            // Handle limited access
            completion(nil, nil)
        @unknown default:
            completion(nil, nil)
        }
    }
}
