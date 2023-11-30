//
//  Negative.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 22/06/2023.
//

import UIKit
import CoreImage

func createNegativeImage(from image: UIImage) -> UIImage? {
    guard let ciImage = CIImage(image: image) else {
        return nil
    }

    let filter = CIFilter(name: "CIColorInvert")
    filter?.setValue(ciImage, forKey: kCIInputImageKey)

    guard let outputCIImage = filter?.outputImage else {
        return nil
    }

    let context = CIContext(options: nil)
    guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
        return nil
    }

    let outputImage = UIImage(cgImage: outputCGImage)

    return outputImage
}

