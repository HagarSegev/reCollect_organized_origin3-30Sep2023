//
//  PhotoLoader.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 28/07/2023.
//

import UIKit

class PhotoLoader {
    
    static let shared = PhotoLoader() // Singleton instance
    
    private(set) var photos: [UIImage?] = Array(repeating: nil, count: 10)
    private var assets: [String?] = Array(repeating: nil, count: 10)
    private(set) var currentIndex: Int = 0
    
    private init() {
    }
    
    func nextPhoto() -> (UIImage?, String?) {
        currentIndex = (currentIndex + 1) % 10 // Loop through photos
        updatePhotoAtIndex((currentIndex + 8) % 10)
        while photos[currentIndex] == nil {
               usleep(100000) // Sleep for 100ms to prevent excessive CPU consumption
           }
        return (photos[currentIndex] , assets[currentIndex])
    }
    
    func loadPhotos() {        
        // Load 10 photos asynchronously
        for i in 0..<10 {
            getRandomPhoto { image, asset in
                if let image = image {
                    DispatchQueue.main.async { [self] in
                        self.photos[i] = image
                        self.assets[i] = asset
                    }
                }
            }
        }
    }
    
    func updatePhotoAtIndex(_ index: Int) {
        // Check if index is valid
        guard index >= 0 && index < photos.count else {
            print("Invalid index.")
            return
        }
        
        // Fetch a new random photo
        getRandomPhoto { image, asset in
            if let image = image {
                DispatchQueue.main.async { [self] in
                    // Replace the photo at the given index with the new photo
                    self.photos[index] = image
                    self.assets[index]  = asset
                }
            }
        }
    }
    func getCurrentPhoto(completion: @escaping (UIImage? , String?) -> ()) {
        // If photo at currentIndex is already loaded, return immediately
        if let currentPhoto = photos[currentIndex] {
            completion(currentPhoto, assets[currentIndex])
        } else {
            // If not loaded yet, wait for it to load
            DispatchQueue.global().async { [self] in
                while photos[currentIndex] == nil {
                    // Sleep for a short duration to prevent busy waiting
                    usleep(100000) // 100 ms
                }
                
                DispatchQueue.main.async { [self] in
                    completion(photos[currentIndex], assets[currentIndex])
                }
            }
        }
    }


}
