//
//  FramedMemory.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 23/07/2023.
//

import UIKit
class FramedMemory: UIView {
    weak public var chooseVC: ChooseVC!
    public var framedMemoryBehavior: FramedMemoryBehavior!
    public let imageView: UIImageView
    public let outerFrame: UIView
    public let whiteFrame: UIView
    public let whiteFrameFrame: UIView
    public let innerFrame: UIView
    public var localIdentifier: String!
    
    var countLabel:UILabel = UILabel()

    
    public var gradient: CAGradientLayer!
    public var blur:UIVisualEffectView!
    
    private var initialImageViewCenter = CGPoint.zero
    
    var animator: UIDynamicAnimator!
    public var gravity: UIGravityBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    private var gravityAdded: Bool = false


    var attachment1: UIAttachmentBehavior!
    var attachment2: UIAttachmentBehavior!
    public var attachmentPoint1: CGPoint!
    public var attachmentPoint2: CGPoint!
    private var gravityAnchorPoint: CGPoint!
    public var objectAttached: Bool = false
    public var objedtInRightSpin: Bool = false
    public var lineLayers: [CAShapeLayer] = []
    
    public var startTime: Date?

//    var panAttachment: UIAttachmentBehavior?
//    var displayLink: CADisplayLink?

    var behavior: FramedMemoryBehavior!
    
    var aspectRatioConstraint: NSLayoutConstraint?
    var selfConstraints = [NSLayoutConstraint]()
    var imageViewConstraints = [NSLayoutConstraint]()
    var outerFrameConstraints = [NSLayoutConstraint]()
    var whiteFrameConstraints = [NSLayoutConstraint]()
    var whiteFrameFrameConstraints = [NSLayoutConstraint]()
    var innerFrameConstraints = [NSLayoutConstraint]()
    

    
    private var padding: CGFloat = 10.0
    private var bottomPadding: CGFloat  = TopBarManager.shared.topBar.frame.height + 20.0 //withount the xv buttons
    //private var bottomPadding: CGFloat  = TopBarManager.shared.topBar.frame.height + 70.0
    private var topPadding: CGFloat  = TopBarManager.shared.topBar.frame.height*1.5 + 30.0
    //private var topPadding: CGFloat  = TopBarManager.shared.topBar.frame.height*1.5 + 10.0 withount the instructions

    init(image: UIImage, localIdentifier: String, chooseVC: ChooseVC) {
        self.chooseVC = chooseVC
        self.imageView = UIImageView(image: image)
        self.localIdentifier = localIdentifier
        self.outerFrame = UIView()
        self.whiteFrame = UIView()
        self.whiteFrameFrame = UIView()
        self.innerFrame = UIView()
//        self.displayLink?.add(to: .current, forMode: .common)

        super.init(frame: .zero)
        self.addSubview(outerFrame)
        self.addSubview(whiteFrame)
        self.addSubview(whiteFrameFrame)
        self.addSubview(innerFrame)
        self.addSubview(imageView)
        self.addSubview(countLabel)
        
        // Round the corners of the imageView
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        // Frame sizes
        outerFrame.translatesAutoresizingMaskIntoConstraints = false
        innerFrame.translatesAutoresizingMaskIntoConstraints = false
        whiteFrame.translatesAutoresizingMaskIntoConstraints = false
        whiteFrameFrame.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false


        // Set outer frame and inner frame border color and width
        outerFrame.layer.borderColor = UIColor.black.cgColor
        outerFrame.layer.borderWidth = 2
        whiteFrameFrame.layer.borderColor = UIColor.black.cgColor
        whiteFrameFrame.layer.borderWidth = 2
        innerFrame.layer.borderColor = UIColor.black.cgColor
        innerFrame.layer.borderWidth = 0
        
        whiteFrame.backgroundColor = .white
        whiteFrame.alpha = 0.2 // Set the alpha value as needed
        
        // add dragging effect
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        
        //specify counting label
        countLabel.text = "\(chooseVC.selectedPhotosCount) / 70"
        countLabel.textAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: self.chooseVC.view.frame.width/15, weight: .bold)
        countLabel.translatesAutoresizingMaskIntoConstraints = false




    }
    
    func setupSuperviewConstraints() {
        guard let superview = self.superview else {
            print("View has no superview yet!")
            return
        }
        
        self.alpha = 0


        // FramedMemory constraints
        selfConstraints = [
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
//            self.widthAnchor.constraint(equalTo: superview.widthAnchor, constant: -2*padding),
//            self.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: topPadding+bottomPadding)
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottomPadding),
        ]
        
        NSLayoutConstraint.activate(selfConstraints)
        

        // imageView constraints
        imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            imageView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, constant: -5*padding),
//            imageView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, constant: -5*padding)
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: padding*3.5),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -padding*3.5),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: padding*3.5),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -padding*3.5),
        ]
        NSLayoutConstraint.activate(imageViewConstraints)

        // outerFrame constraints
        outerFrameConstraints = [
            outerFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            outerFrame.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            outerFrame.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 6*padding),
//            outerFrame.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant:6*padding)
            outerFrame.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -3*padding),
            outerFrame.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 3*padding),
            outerFrame.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -3*padding),
            outerFrame.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3*padding),
        ]
        NSLayoutConstraint.activate(outerFrameConstraints)

        
        // innerFrame constraints
        whiteFrameConstraints = [
            whiteFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            whiteFrame.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            whiteFrame.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 4*padding),
//            whiteFrame.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant: 4*padding)
            whiteFrame.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -padding*2),
            whiteFrame.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding*2),
            whiteFrame.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -padding*2),
            whiteFrame.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding*2),
        ]
        
        NSLayoutConstraint.activate(whiteFrameConstraints)

        // innerFrame constraints
        whiteFrameFrameConstraints = [
            whiteFrameFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            whiteFrameFrame.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            whiteFrameFrame.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 4*padding),
//            whiteFrameFrame.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant: 4*padding)
            whiteFrameFrame.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -padding*2),
            whiteFrameFrame.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding*2),
            whiteFrameFrame.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -padding*2),
            whiteFrameFrame.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding*2),
        ]
        
        NSLayoutConstraint.activate(whiteFrameFrameConstraints)

        
        // innerFrame constraints
        innerFrameConstraints = [
            innerFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            innerFrame.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            innerFrame.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 0.4*padding),
//            innerFrame.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant: 0.4*padding)
            innerFrame.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -padding*0.2),
            innerFrame.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding*0.2),
            innerFrame.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -padding*0.2),
            innerFrame.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding*0.2),
        ]
        NSLayoutConstraint.activate(innerFrameConstraints)


        let imageAspectRatio = (imageView.image?.size.width ?? 1) / (imageView.image?.size.height ?? 1)
        aspectRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageAspectRatio)
        aspectRatioConstraint?.isActive = true
        
                
        NSLayoutConstraint.activate([
//            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4),
//            countLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: FramedMemoryPadding)
            countLabel.leadingAnchor.constraint(equalTo: outerFrame.leadingAnchor, constant: padding*4),
            countLabel.bottomAnchor.constraint(equalTo: outerFrame.topAnchor)
        ])

    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        let height = TopBarManager.shared.topBar.bottomAnchor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !gravityAdded {
            applyGravity()
            addGradientandBlur()
            gravityAdded = true
        }
    }
    
    func addGradientandBlur(){
        gradient = CAGradientLayer()
        blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))  // .extraLight or .dark
        gradient.frame = outerFrame.bounds
        gradient.colors = [orangeGradient.cgColor, blueGradient.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.6)
        outerFrame.layer.insertSublayer(gradient, at: 0)
        gradient.opacity = 0
        
        
        blur.frame = outerFrame.bounds
        blur.alpha = 1
        outerFrame.addSubview(blur)

    }
    
//    @objc func updateGradient() {
//        let transform = self.transform
//        let angle = atan2(Double(transform.b), Double(transform.a))
//
//        // Convert the angle range (-π to π) to range (0 to 1)
//        let normalizedAngle = angle / (2 * Double.pi) + 0.5
//
//        // Modify the gradient opacity according to the angle
//        gradient.opacity = Float(max(0,normalizedAngle))
//    }
    

    
   
    
    func applyGravity() {
        self.gravityAnchorPoint = CGPoint(x: self.center.x,
                                          y: outerFrame.center.y - outerFrame.frame.size.height/2 - padding*2)

        // Add dynamic animator and gravity behavior
        animator = UIDynamicAnimator(referenceView: self.superview!)
        gravity = UIGravityBehavior(items: [self])
        animator.addBehavior(gravity)

        // Create dynamic item behavior
        dynamicItemBehavior = UIDynamicItemBehavior(items: [self])
        dynamicItemBehavior.allowsRotation = true
        dynamicItemBehavior.angularResistance = 2
        dynamicItemBehavior.addAngularVelocity(CGFloat(Float.random(in: 0..<0.2)), for: self)
        animator.addBehavior(dynamicItemBehavior)

        // Find anchor point above outerFrame

        let attachmentOffset1 = UIOffset(horizontal: -padding, vertical: -outerFrame.frame.size.height/2)
        let attachmentOffset2 = UIOffset(horizontal: padding, vertical: -outerFrame.frame.size.height/2)

        attachmentPoint1 = CGPoint(x: self.frame.midX + attachmentOffset1.horizontal, y: outerFrame.center.y + attachmentOffset1.vertical)
        attachmentPoint2 = CGPoint(x: self.frame.midX + attachmentOffset2.horizontal, y: outerFrame.center.y + attachmentOffset2.vertical)

        let distance1 = sqrt(pow(attachmentPoint1.x - gravityAnchorPoint.x, 2) + pow(attachmentPoint1.y - gravityAnchorPoint.y, 2))
        let distance2 = sqrt(pow(attachmentPoint2.x - gravityAnchorPoint.x, 2) + pow(attachmentPoint2.y - gravityAnchorPoint.y, 2))

        
        let aOF1 = UIOffset(horizontal: -padding, vertical: -outerFrame.frame.size.height/2 - (self.frame.midY - outerFrame.frame.midY))
        let aOF2 = UIOffset(horizontal: padding, vertical: -outerFrame.frame.size.height/2 - (self.frame.midY - outerFrame.frame.midY))

        attachment1 = UIAttachmentBehavior(item: self, offsetFromCenter: aOF1, attachedToAnchor: gravityAnchorPoint)
        attachment2 = UIAttachmentBehavior(item: self, offsetFromCenter: aOF2, attachedToAnchor: gravityAnchorPoint)

        attachment1.length = distance1
        attachment2.length = distance2

        animator.addBehavior(attachment1)
        animator.addBehavior(attachment2)


        drawConnectionLines()
        
//        self.displayLink = CADisplayLink(target: self, selector: #selector(updateGradient))
        
        behavior = FramedMemoryBehavior(memoryView: self)
        animator.addBehavior(behavior)
        
        objectAttached = true

    }
    
    func drawConnectionLines() {
        // Remove all existing line layers
        for layer in lineLayers {
            layer.removeFromSuperlayer()
        }
        lineLayers.removeAll()
        
        // Draw lines
        drawLine(from: gravityAnchorPoint, to: attachmentPoint1, lineWidth: 2)
        drawLine(from: gravityAnchorPoint, to: attachmentPoint2, lineWidth: 2)
        // draw corner lines
        
        drawLine(from: outerFrame.frame.origin, to: whiteFrame.frame.origin, lineWidth: 1)
        drawLine(from:  CGPoint(x: outerFrame.frame.maxX, y: outerFrame.frame.origin.y), to: CGPoint(x: whiteFrame.frame.maxX, y: whiteFrame.frame.origin.y), lineWidth: 1)
        drawLine(from: CGPoint(x: outerFrame.frame.origin.x, y: outerFrame.frame.maxY), to: CGPoint(x: whiteFrame.frame.origin.x, y: whiteFrame.frame.maxY), lineWidth: 1)
        drawLine(from: CGPoint(x: outerFrame.frame.maxX, y: outerFrame.frame.maxY), to: CGPoint(x: whiteFrame.frame.maxX, y: whiteFrame.frame.maxY), lineWidth: 1)
    }
    
    

    
    func drawLine(from start: CGPoint, to end: CGPoint, lineWidth: CGFloat) {
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)

        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.lineWidth = lineWidth
        lineLayer.lineJoin = .miter
        self.layer.addSublayer(lineLayer)
        
        lineLayers.append(lineLayer)
    }
    
    public var lastTranslation: CGPoint = .zero
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.superview)
        switch gestureRecognizer.state {
        case .began:
            // When the gesture begins, remove the gravity
            animator.removeBehavior(gravity)
            
            // And set the dynamic item behavior to allow rotation
            dynamicItemBehavior.allowsRotation = true
            dynamicItemBehavior.angularResistance = 0
            lastTranslation = translation
            
        case .changed:
            // As the gesture changes, update the rotation of the view according to the movement of the gesture
//            let velocity = gestureRecognizer.velocity(in: self.superview)
            let latestXoffset = translation.x - lastTranslation.x
            
            let angle = -latestXoffset * 0.12

            // Reset the angular velocity to zero before adding new velocity
            dynamicItemBehavior.addAngularVelocity(-dynamicItemBehavior.angularVelocity(for: self), for: self)
            
            dynamicItemBehavior.addAngularVelocity(angle, for: self)
            
            if (latestXoffset > 25){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.swipeRightBehavior()
                }
            }
            else if (latestXoffset < -25){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.swipeLeftBehavior()
                }
            }
            
            lastTranslation = translation

        case .ended, .cancelled:
            // When the gesture ends or is cancelled, add back the gravity
            if !objectAttached { return}
            animator.addBehavior(gravity)
            
            // And set the dynamic item behavior to prevent rotation
            dynamicItemBehavior.angularResistance = 2.5 // high value to prevent rotation

        default:
            break
        }
    }
    
    func prepareForDeallocation() {
        // Remove animator and behaviors
        animator.removeAllBehaviors()
        animator = nil
        
        // Remove behaviors
        gravity = nil
        dynamicItemBehavior = nil
        attachment1 = nil
        attachment2 = nil
//        panAttachment = nil
        behavior = nil

        // Clear pointers
        chooseVC = nil
        attachmentPoint1 = nil
        attachmentPoint2 = nil
        gravityAnchorPoint = nil

        // Remove layers
        gradient.removeFromSuperlayer()
        gradient = nil
        blur.removeFromSuperview()
        blur = nil
        for layer in lineLayers {
            layer.removeFromSuperlayer()
        }
        countLabel.removeFromSuperview()
        lineLayers.removeAll()
        

        // Deactivate constraints
        NSLayoutConstraint.deactivate(selfConstraints)
        NSLayoutConstraint.deactivate(imageViewConstraints)
        NSLayoutConstraint.deactivate(outerFrameConstraints)
        NSLayoutConstraint.deactivate(whiteFrameConstraints)
        NSLayoutConstraint.deactivate(whiteFrameFrameConstraints)
        NSLayoutConstraint.deactivate(innerFrameConstraints)
        if let aspectRatioConstraint = aspectRatioConstraint {
            aspectRatioConstraint.isActive = false
        }

        // Remove views
        imageView.removeFromSuperview()
        outerFrame.removeFromSuperview()
        whiteFrame.removeFromSuperview()
        whiteFrameFrame.removeFromSuperview()
        innerFrame.removeFromSuperview()
        imageView.image = nil

        
        
        // Remove additional pointers:
        self.localIdentifier = nil
        self.startTime = nil
        

        
    }
    
    
    deinit {
        print("\(self) is being deallocated")
    }
    
    
    func tapRightBehavior() {
        if !self.objectAttached {
            return
        }
        
        self.chooseVC.increaseCount()
        self.objectAttached = false
        self.objedtInRightSpin = true
        addGradientandBlur()
        gradient.opacity = 0
        guard let startTime = self.startTime else {
            // Handle the case when startTime is nil
            return
        }
        
        let endTime = Date()
        let responseTime = endTime.timeIntervalSince(startTime)
        
        DataSet.shared.addApprovedPhotoData(photoLocation: self.localIdentifier, significanceValue: 1, image: self.imageView.image!)
        
        FirebaseManager.shared.uploadPhoto(localIdentifier: self.localIdentifier, significanceRating: 1, image: self.imageView.image!, timeInterval: responseTime) { error in
            if let error = error {
                print("Failed to upload photo: \(error.localizedDescription)")
            } else {
                print("Photo uploaded successfully!")
            }
        }
        
        DataSet.shared.shownPhotos.append(self.localIdentifier)
        UIView.animate(withDuration: 0.5) {
            self.gradient.opacity = 0.6
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5 ) {
            UIView.transition(with: self.imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.updateImage()
            }, completion: nil)

        }
    }

    func tapLeftBehavior() {
        if !self.objectAttached {
            return
        }
        
        self.objectAttached = false
        DataSet.shared.shownPhotos.append(self.localIdentifier)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: self.imageView, duration: 1.0 , options: .transitionCrossDissolve, animations: {
                self.updateImage()
            }, completion: nil)
        }
    }
    

 

    // Function to handle left swipe behavior with animation

    
}
