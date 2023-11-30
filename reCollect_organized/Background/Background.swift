//
//  Background.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 20/06/2023.


import UIKit

class Background: NSObject {
    public let imageView: UIImageView
    public let negativeImageView: UIImage
    private var curScale: CGFloat = 1.0
    private var curX: CGFloat = 0.0
    private var curY: CGFloat = 0.0
    private var curOpacity: CGFloat = 1.0
    private var scrollIninialX: CGFloat = 0.0
    private var scrollIninialY: CGFloat = 0.0
    private var scrollIninialScale: CGFloat = 0.0
    private var scrollViewEffects: [UIScrollView: BackgroundEffect] = [:]
    
    // Shared instance
    static let shared: Background = {
        let instance = Background(image: UIImage(named: "BackgroundImg")!)
        // setup code
        return instance
    }()
    
    private init(image: UIImage) {
        imageView = UIImageView(image: image)
        negativeImageView  = createNegativeImage(from: image)!
        imageView.alpha = 0.0
        super.init()
    }
    
    func addEffect(to scrollView: UIScrollView, effect: BackgroundEffect) {
        scrollView.delegate = self
        scrollViewEffects[scrollView] = effect
    }
    
    func removeEffect(from scrollView: UIScrollView) {
        scrollView.delegate = nil
        scrollViewEffects.removeValue(forKey: scrollView)
    }
    
    func changeOpacity(to opacity: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            self.imageView.alpha = opacity
        }
    }

    func changeZoom(newScale: CGFloat, newX: CGFloat, newY: CGFloat, duration: TimeInterval ,delay: CGFloat = 0, options: UIView.AnimationOptions = .curveEaseInOut, completion: (() -> Void)? = nil) {
        curScale = newScale
        curX = newX
        curY = newY
        
        //        UIView.animate(withDuration: duration, delay: delay, options: options) {
        //            let transform = CGAffineTransform(scaleX: newScale, y: newScale).translatedBy(x: newX, y: newY)
        //            self.imageView.transform = transform
        //        }
        UIView.animate(withDuration: duration, delay: TimeInterval(delay), options: options, animations: {
            let transform = CGAffineTransform(scaleX: newScale, y: newScale).translatedBy(x: newX, y: newY)
            self.imageView.transform = transform
        }, completion: { finished in
            if finished {
                completion?() // Call the completion closure only if it's provided and the animation completes
            }
        })
    }
    func changeZoom(newScale: CGFloat, newX: CGFloat, duration: TimeInterval) {
        changeZoom(newScale: newScale, newX: newX, newY: curY, duration: duration)
    }

    func changeZoom(newScale: CGFloat, newY: CGFloat, duration: TimeInterval) {
        changeZoom(newScale: newScale, newX: curX, newY: newY, duration: duration)
    }

    func changeZoom(newX: CGFloat, newY: CGFloat, duration: TimeInterval) {
        changeZoom(newScale: curScale, newX: newX, newY: newY, duration: duration)
    }
    
    func changeZoom(newScale: CGFloat, duration: TimeInterval) {
        changeZoom(newScale: newScale, newX: curX, newY: curY, duration: duration)
    }
    
    func changeZoom(newX: CGFloat, duration: TimeInterval) {
        changeZoom(newScale: curScale, newX: newX, newY: curY, duration: duration)
    }
    
    func changeZoom(newY: CGFloat, duration: TimeInterval) {
        changeZoom(newScale: curScale, newX: curX, newY: newY, duration: duration)
    }
    
    func changeZoom(moveRight: CGFloat, duration: TimeInterval, delay: CGFloat = 0, options: UIView.AnimationOptions = .curveEaseInOut) {
        changeZoom(newScale: curScale, newX: curX + moveRight, newY: curY, duration: duration, delay: delay, options: options)
    }
    /**
     Getters
     */
    public func getCurrentScale() -> CGFloat {
        return curScale
    }
    
    func getCurrentX() -> CGFloat {
        return curX
    }
    
    func getCurrentY() -> CGFloat {
        return curY
    }
    
    func getCurrentOpacity() -> CGFloat {
        return curOpacity
    }
    
    func setScrollInitials() {
        scrollIninialX = getCurrentX()
        scrollIninialY = getCurrentY()
        scrollIninialScale = getCurrentScale()
    }
}

extension Background: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let effect = scrollViewEffects[scrollView] else {
            return
        }

//        let initialX = scrollView.getCurrentX()
//        let initialY = scrollView.getCurrentY()
//        let initialScale = scrollView.getCurrentScale()
//        let initialOpacity = scrollView.getCurrentOpacity()
        
        let initialX = self.scrollIninialX
        let initialY = self.scrollIninialY
        let initialScale = self.scrollIninialScale

        let contentOffset = scrollView.contentOffset

        let newScale: CGFloat = effect.calculateZoomScale(for: contentOffset, initialScale: initialScale)
        let newX: CGFloat = effect.calculateXOffset(for: contentOffset, initialX: initialX, curScale: curScale)
        let newY: CGFloat = effect.calculateYOffset(for: contentOffset, initialY: initialY)

        changeZoom(newScale: newScale, newX: newX, newY: newY, duration: 0)
    }
}

