//
//  CompareDomain.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 07/09/2023.
//

//Usage:
//let recencyDomain = CompareDomain(domain: .recency)

import UIKit

class CompareDomain {
    let domain: Domain
    var svgFileName: String
    var caption: String
    
    var randomPhotoCouples: [[String]] = []

    
    var indexComparison:Int = 0
    var compareButtons: CompareButtons!

    init(domain: Domain) {
        self.domain = domain
        self.svgFileName = domain.svgFileName
        self.caption = domain.caption
        fillRandomPhotoCouples()
        compareButtons = CompareButtons()
        compareButtons.setNewImages(identifier1: randomPhotoCouples[0][0],
                                    identifier2: randomPhotoCouples[0][1])
    }
    
    private func nextCompare(){
        if indexComparison < 9 {
            indexComparison += 1
            compareButtons.setNewImages(identifier1: randomPhotoCouples[indexComparison][0],
                                        identifier2: randomPhotoCouples[indexComparison][1])
        }
        
        else {
            
        }
    }
    
    
    
    private func fillRandomPhotoCouples() {
        randomPhotoCouples.removeAll() // Clear any existing data
        
        let allPhotoLocations = Array(DataSet.shared.approvedPhotosData.keys)
        
        // Ensure there are enough photos to create couples
        guard allPhotoLocations.count >= 2 else { return }
        
        var availablePhotoLocations = allPhotoLocations
        
        for _ in 1...10 {
            // Ensure there are at least 2 photos left to form a couple
            guard availablePhotoLocations.count >= 2 else { break }
            
            let randomIndices = pickTwoRandomIndices(from: availablePhotoLocations.count)
            
            let couple = [availablePhotoLocations[randomIndices.0], availablePhotoLocations[randomIndices.1]]
            randomPhotoCouples.append(couple)
            
            // Remove the selected photos so they aren't picked again
            availablePhotoLocations.remove(at: randomIndices.1) // Remove the larger index first to avoid index out of range
            availablePhotoLocations.remove(at: randomIndices.0)
        }
    }
    
    private func pickTwoRandomIndices(from size: Int) -> (Int, Int) {
        let firstIndex = Int.random(in: 0..<size)
        var secondIndex: Int
        repeat {
            secondIndex = Int.random(in: 0..<size)
        } while firstIndex == secondIndex
        
        return (firstIndex, secondIndex)
    }
}

