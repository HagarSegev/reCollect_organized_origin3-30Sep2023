//
//  BackgroundEffect.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 20/06/2023.
//
import UIKit

protocol BackgroundEffect {
    func calculateZoomScale(for contentOffset: CGPoint, initialScale: CGFloat) -> CGFloat
    func calculateXOffset(for contentOffset: CGPoint, initialX: CGFloat, curScale: CGFloat) -> CGFloat
    func calculateYOffset(for contentOffset: CGPoint, initialY: CGFloat) -> CGFloat
}

// Example BackgroundEffect implementation for effect1
struct Effect1: BackgroundEffect {
    func calculateZoomScale(for contentOffset: CGPoint, initialScale: CGFloat) -> CGFloat {
        // Calculate the desired zoom scale based on the content offset
        // Example implementation:
        let maxZoom: CGFloat = 2.0
        let minZoom: CGFloat = 1.0
        let range: CGFloat = 100.0 // Example range for zoom effect
        let normalizedOffset = min(max(contentOffset.y, 0), range) // Clamp offset value within the range
        let normalizedZoom = ((normalizedOffset / range) * (maxZoom - minZoom)) + minZoom
        return normalizedZoom
    }

    func calculateXOffset(for contentOffset: CGPoint, initialX: CGFloat, curScale: CGFloat) -> CGFloat {
        // Calculate the desired X offset based on the content offset
        // Example implementation:
        let range: CGFloat = 100.0 // Example range for X offset effect
        let normalizedOffset = min(max(contentOffset.y, 0), range) // Clamp offset value within the range
        let normalizedXOffset = (normalizedOffset / range) * 50.0 // Example maximum X offset of 50.0
        return normalizedXOffset
    }

    func calculateYOffset(for contentOffset: CGPoint, initialY: CGFloat) -> CGFloat {
        // Calculate the desired Y offset based on the content offset
        // Example implementation:
        let range: CGFloat = 100.0 // Example range for Y offset effect
        let normalizedOffset = min(max(contentOffset.y, 0), range) // Clamp offset value within the range
        let normalizedYOffset = (normalizedOffset / range) * 50.0 // Example maximum Y offset of 50.0
        return normalizedYOffset
    }
}

struct Effect2: BackgroundEffect {
    func calculateZoomScale(for contentOffset: CGPoint, initialScale: CGFloat) -> CGFloat {
        // Calculate the desired zoom scale based on the content offset
        // Example implementation:
        return initialScale // No change in zoom scale
    }

    func calculateXOffset(for contentOffset: CGPoint, initialX: CGFloat, curScale: CGFloat) -> CGFloat {
        // Calculate the desired X offset based on the content offset and current scale
        // Example implementation:
        let range: CGFloat = 100.0 
        var xOffset = initialX // Initialize with the current X offset
        let moveAmount: CGFloat = contentOffset.y/40 // Amount to move the background

//        if contentOffset.y > 0 {
//            // When scrolling down (positive content offset), move the background to the right
//            xOffset += moveAmount
//        } else if contentOffset.y < 0 {
//            // When scrolling up (negative content offset), move the background to the left
//            xOffset -= moveAmount
//        }

        return initialX + moveAmount
    }

    func calculateYOffset(for contentOffset: CGPoint, initialY: CGFloat) -> CGFloat {
        // Calculate the desired Y offset based on the content offset
        // Example implementation:
        return initialY + contentOffset.y/70 // No change in Y offset
    }
}
//
//struct Effect3: BackgroundEffect {
//    func calculateZoomScale(for contentOffset: CGPoint, initialScale curScale: CGFloat) -> CGFloat {
//        // Calculate the desired zoom scale based on the content offset
//        // Example implementation:
//        return curScale // No change in zoom scale
//    }
//
//    func calculateXOffset(for contentOffset: CGPoint, initialX curX: CGFloat, curScale: CGFloat) -> CGFloat {
//        // Calculate the desired X offset based on the content offset and current scale
//        // Example implementation:
//        let maxOffset: CGFloat = 20.0 // Maximum offset in the x direction
//
//        // Access the scroll view through the contentOffset's associated UIScrollView instance
//        guard let scrollView = contentOffset.associatedScrollView else {
//            return curX // Return the current X offset if the associated UIScrollView is not found
//        }
//
//        // Calculate the normalized x position of the scroll view's frame within the scroll view's content size
//        let normalizedPosition = contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
//
//        // Calculate the desired x offset based on the normalized position and maximum offset
//        let desiredOffset = maxOffset * normalizedPosition
//
//        // Add the desired offset to the current x position
//        let newX = curX + desiredOffset
//
//        return newX
//    }
//
//    func calculateYOffset(for contentOffset: CGPoint, initialY curY: CGFloat) -> CGFloat {
//        // Calculate the desired Y offset based on the content offset
//        // Example implementation:
//        return curY // No change in Y offset
//    }
//}
//
