//
//  CompareButtons.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 07/09/2023.
//

import Foundation


import UIKit
import Photos

class CompareButtons {
    var button1: UIButton!
    var button2: UIButton!
    var vsLabel: UILabel!
    private var scaleBehavior = ScaleBehavior()
    private let spacing: CGFloat = UIScreen.main.bounds.width / 20
    
    
    init() {
        
        button1 = UIButton(type: .custom)
        button2 = UIButton(type: .custom)
        
        scaleBehavior.apply(to: button1)
        scaleBehavior.apply(to: button2)
        
        button1.alpha = 0
        button2.alpha = 0
        vsLabel.alpha = 0
        setupLayout()
        
    }
    
    public func setNewImages(identifier1: String, identifier2: String){
        if let image1 = fetchImage(for: identifier1) {
            button1.setImage(image1, for: .normal)
        }
        
        if let image2 = fetchImage(for: identifier2) {
            button2.setImage(image2, for: .normal)
        }
    }
    
    
    private func setupLayout() {
        // Calculate max width and height
        let maxWidth = UIScreen.main.bounds.width - 2 * spacing
        let maxHeight = (UIScreen.main.bounds.height / 2) - TopBarManager.shared.topBar.frame.height - 2 * spacing
        
        // Determine button size
        let buttonSize = min(maxWidth, maxHeight)
        
        // Set button frame for button1
        let button1Xoffset = (UIScreen.main.bounds.width - buttonSize) / 2 - 100 // Centered on x-axis
        let button1Y = (UIScreen.main.bounds.height / 2) - buttonSize - spacing // Spacing above the center
        button1.frame = CGRect(x: button1Xoffset, y: button1Y, width: buttonSize, height: buttonSize)
        
        // Set button frame for button2
        let button2Xoffset = (UIScreen.main.bounds.width - buttonSize) / 2 + 100 // Centered on x-axis
        let button2Y = UIScreen.main.bounds.height / 2 + spacing // Spacing below the center
        button2.frame = CGRect(x: button2Xoffset, y: button2Y, width: buttonSize, height: buttonSize)
        
        vsLabel = UILabel()
        vsLabel.text = "Vs."
        vsLabel.textAlignment = .center
        vsLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold) // may be adjusted to different phones
        vsLabel.sizeToFit()
        
        // Position the label at the center of the screen
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2
        vsLabel.center = CGPoint(x: centerX, y: centerY)
        
        let button1X = (UIScreen.main.bounds.width - buttonSize) / 2
        let button2X = (UIScreen.main.bounds.width - buttonSize) / 2
        UIView.animate(withDuration: 0.5, animations: { [self] in
            button1.frame = CGRect(x: button1X, y: button1Y, width: buttonSize, height: buttonSize)
            button2.frame = CGRect(x: button2X, y: button2Y, width: buttonSize, height: buttonSize)
            button1.alpha = 1
            button2.alpha = 1
            vsLabel.alpha = 1
        })
    }
    
    private func fetchImage(for localIdentifier: String) -> UIImage? {
            let fetchOptions = PHFetchOptions()
            fetchOptions.fetchLimit = 1
            let result = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: fetchOptions)
            
            guard let asset = result.firstObject else { return nil }
            
            var fetchedImage: UIImage?
            let manager = PHImageManager.default()
            let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, _) in
                fetchedImage = image
            }
            
            return fetchedImage
        }
}
