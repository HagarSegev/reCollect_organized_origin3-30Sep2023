//
//  File.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 27/07/2023.
//
import UIKit

class FramedMemoryBehavior: UIDynamicBehavior {

    let memoryView: FramedMemory
    
    init(memoryView: FramedMemory) {
        self.memoryView = memoryView
        super.init()
        
        // You could add any other behaviors (e.g. UIAttachmentBehavior, UIGravityBehavior, etc.)
        // to this composite behavior, and they would all influence the `memoryView`.
        // Here is just a basic example:

        
        // The `action` closure is called every animation frame.
        action = { [unowned self] in
            self.memoryView.updateGradientOpacityAndBlurAlpha()
        }
    }
}

extension FramedMemory {
    

    
    func updateGradientOpacityAndBlurAlpha() {
        guard let superView = self.superview else { return }
        
        // Calculate normalized position of the center of the FramedMemory (-1...1)
        let normalizedPosition = (self.center.x / superView.frame.size.width - 0.5) * 2
        
        
        if (normalizedPosition > 0) {
            // Update animated objects
            gradient.opacity = Float(normalizedPosition)
            
            if (normalizedPosition > 1.1 &&
                lastTranslation.x > 0 &&
                !objedtInRightSpin){
                
                swipeRightBehavior()
            }
        }
        else if (normalizedPosition < 0){
            // Update animated objects
            self.alpha = 1 + normalizedPosition/2
            whiteFrame.alpha = 1 + normalizedPosition
            blur.alpha = 1 + normalizedPosition
            
            if (normalizedPosition < -1.1){
                if (objedtInRightSpin){
                    
                }
                else if(dynamicItemBehavior.angularVelocity(for: self)>0 &&
                        lastTranslation.x < 0 &&
                        objectAttached){
                    
                    swipeLeftBehavior()
                }
            }
        }
    }
    
//    func swipeRightBehavior(){
//        self.objedtInRightSpin = true
//        self.dynamicItemBehavior.addAngularVelocity(-20, for: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            UIView.animate(withDuration: 1, animations: {self.alpha = 0})
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.dynamicItemBehavior.addAngularVelocity(-20, for: self)
//
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.updateImage()
//            }
//        }
//    }
    
    func swipeRightBehavior(){
        if !self.objectAttached {
            return
        }
        self.chooseVC.increaseCount()
        self.objectAttached = false
        self.objedtInRightSpin = true
        let responseTime = responseTime()
        DataSet.shared.addApprovedPhotoData(photoLocation: self.localIdentifier , significanceValue: 1, image: self.imageView.image!)
        FirebaseManager.shared.uploadPhoto(localIdentifier: self.localIdentifier, significanceRating: 1, image: self.imageView.image!, timeInterval: responseTime) { error in
            if let error = error {
                print("Failed to upload photo: \(error.localizedDescription)")
            } else {
                print("Photo uploaded successfully!")
            }
        }
        DataSet.shared.shownPhotos.append(self.localIdentifier)
            animator.removeBehavior(attachment2)
            
            // Combine animations with removal behaviors and image update
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { _ in
                self.animator.removeBehavior(self.attachment1)
                self.gravity.gravityDirection = CGVector(dx: 0, dy: -1)
                DispatchQueue.main.asyncAfter(deadline: .now() ) {
                    self.updateImage()
                }
            }

        
//        self.dynamicItemBehavior.addAngularVelocity(-20, for: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            UIView.animate(withDuration: 1, animations: {self.alpha = 0})
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.dynamicItemBehavior.addAngularVelocity(-20, for: self)
//
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.updateImage()
//            }
//        }
        
    }
    
    func swipeLeftBehavior(){
        if !self.objectAttached {
            return
        }
        self.objectAttached = false
        DataSet.shared.shownPhotos.append(self.localIdentifier)
        animator.removeBehavior(attachment1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animator.removeBehavior(self.attachment2)
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.updateImage()
            }
        }

        
        
    }
    
//    func updateImage() {
//
//        let newImage = PhotoLoader.shared.nextPhoto()
//        self.imageView.image = newImage
//
//        // Update aspect ratio constraint
//        if let constraint = aspectRatioConstraint {
//            NSLayoutConstraint.deactivate([constraint])
//        }
//
//        imageView.contentMode = .scaleAspectFill
//
//        // Update constraints or layout if the new image's size is different
//        self.layoutIfNeeded()
////        self.imageView.layoutIfNeeded()
////        self.outerFrame.layoutIfNeeded()
////        self.whiteFrame.layoutIfNeeded()
////        self.whiteFrameFrame.layoutIfNeeded()
////        self.innerFrame.layoutIfNeeded()
//
//
//
//
//        let imageAspectRatio = (newImage!.size.width) / (newImage!.size.height)
//        aspectRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageAspectRatio)
//        aspectRatioConstraint?.isActive = true
//
//        blur.frame = outerFrame.bounds
//        gradient.frame = outerFrame.bounds
//
//        drawConnectionLines()
//    }
//    func updateImage(){
//
//        DispatchQueue.main.async{ [chooseVC = self.chooseVC] in
//            let prevSelfToRemove = self
//            let newImage = PhotoLoader.shared.nextPhoto()
//            let newSelf = FramedMemory(image: newImage!, chooseVC: chooseVC!)
//
//            guard let superView = prevSelfToRemove.superview else {
//                print("No superview!")
//                return
//            }
//            // TODO: animation of fade out
//            prevSelfToRemove.removeFromSuperview()
//            prevSelfToRemove.chooseVC = nil
//
//            newSelf.chooseVC!.framedMemory = newSelf
//
//
//            // Add `framedMemory` to your view hierarchy
//            newSelf.chooseVC!.view.addSubview(chooseVC!.framedMemory)
//
//            newSelf.chooseVC!.framedMemory.setupSuperviewConstraints()
//
//            UIView.animate(withDuration: 1, animations: {
//                newSelf.chooseVC!.framedMemory.alpha = 1
//            })
//        }
//    }
    
    func updateImage() {
        DispatchQueue.main.async { [chooseVC = self.chooseVC] in
            let prevSelfToRemove = self
            let photo = PhotoLoader.shared.nextPhoto()
            let newImage = photo.0
            let localIdentifier = photo.1
            self.addNextButton()
            let newSelf = FramedMemory(image: newImage!,localIdentifier: localIdentifier!, chooseVC: chooseVC!)
            
//            guard let superView = prevSelfToRemove.superview else {
//                print("No superview!")
//                return
//            }
//
            // Prepare for deallocation
            prevSelfToRemove.prepareForDeallocation()
            
            // Remove from superview
            prevSelfToRemove.removeFromSuperview()
            
            newSelf.chooseVC!.framedMemory = newSelf
            
            // Add `framedMemory` to your view hierarchy
            newSelf.chooseVC!.view.addSubview(newSelf.chooseVC!.framedMemory)
            
            newSelf.chooseVC!.framedMemory.setupSuperviewConstraints()
            
            UIView.animate(withDuration: 0.3, animations: {newSelf.chooseVC!.framedMemory.alpha = 1}){_ in
                newSelf.startTime = Date()
            }
        }
    }
    
    func addNextButton(){
        let count = DataSet.shared.numberOfApprovedPhotos()
        print("Number of approved photos: \(count)") // Log the count for debugging
        let enoughPhotos = count == 70
        
        if enoughPhotos {
            if ((self.behavior) != nil){
                self.chooseVC.nextButton.animateButton(shouldShow: enoughPhotos)

            }
        }
    }
    
    func responseTime() -> TimeInterval{
        let endTime = Date()
        let start = startTime!
        let elapsedTime = endTime.timeIntervalSince(start)
        return elapsedTime
    }
    
    

}
