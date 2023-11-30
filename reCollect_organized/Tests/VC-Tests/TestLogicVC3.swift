
import UIKit
import Photos


class TestLogicVC3: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    let view: UIView
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var attachmentBehaviors: [UIAttachmentBehavior] = []
    var myView: UIImageView!
    var attachmentViews: [UIView] = []
    var initialDistance: CGFloat = 0
    var dragBehavior: UIAttachmentBehavior?
    var displayLink: CADisplayLink?
    
    var line1: CAShapeLayer!
    var line2: CAShapeLayer!


    var itemBehavior: UIDynamicItemBehavior!
    
    init(view: UIView) {
        self.view = view
    }

    func setupView() {
        // Create an empty UIImageView first
        myView = UIImageView(frame: CGRect(x: 150, y: 300, width: 100, height: 100))
        myView.isUserInteractionEnabled = true
        myView.contentMode = .scaleAspectFit
        myView.alpha = 0
        view.addSubview(myView)

        // Fetch random photo
        getRandomPhoto { (image,localIdentifier) in
            guard let image = image else {
                print("Failed to get random photo")
                return
            }

            DispatchQueue.main.async {
                self.myView.image = image
                self.myView.frame = CGRect(x: 150, y: 300, width: image.size.width, height: image.size.height)
            }
        }
        animator = UIDynamicAnimator(referenceView: view)
        
        itemBehavior = UIDynamicItemBehavior(items: [myView])
//        itemBehavior.density = 1000 // Adjust to your liking
        itemBehavior.resistance = 2 // Adjust as needed
//        itemBehavior.friction = 10   // Adjust as needed
        animator.addBehavior(itemBehavior)

        // Add gravity
        gravity = UIGravityBehavior(items: [myView])
        animator.addBehavior(gravity)

        // Attach the view to an anchor point
        let anchorPoint = CGPoint(x: myView.center.x, y: myView.center.y - 200)
        initialDistance = sqrt(pow(myView.center.x - anchorPoint.x, 2) + pow(myView.center.y - anchorPoint.y, 2)) // Calculate the initial distance

        // For the top left corner
        let offset1 = UIOffset(horizontal: -myView.bounds.width / 2, vertical: -myView.bounds.height / 2)
        let attachmentBehavior1 = UIAttachmentBehavior(item: myView, offsetFromCenter: offset1, attachedToAnchor: anchorPoint)
        attachmentBehavior1.length = initialDistance
        attachmentBehavior1.damping = 1.0
        attachmentBehavior1.frequency = 2.0
        animator.addBehavior(attachmentBehavior1)
        attachmentBehaviors.append(attachmentBehavior1)

        // For the top right corner
        let offset2 = UIOffset(horizontal: myView.bounds.width / 2, vertical: -myView.bounds.height / 2)
        let attachmentBehavior2 = UIAttachmentBehavior(item: myView, offsetFromCenter: offset2, attachedToAnchor: anchorPoint)
        attachmentBehavior2.length = initialDistance
        attachmentBehavior2.damping = 1.0
        attachmentBehavior2.frequency = 2.0
        animator.addBehavior(attachmentBehavior2)
        attachmentBehaviors.append(attachmentBehavior2)


        // Add pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        myView.addGestureRecognizer(panGesture)

        // Start the display link
        displayLink = CADisplayLink(target: self, selector: #selector(updateLines))
        displayLink?.add(to: .current, forMode: .default)
    }

    
    @objc func updateLines() {
        // Remove old lines
        line1?.removeFromSuperlayer()
        line2?.removeFromSuperlayer()

        // Calculate top left and right corners of the red square
        let topLeftPoint = myView.convert(CGPoint(x: 0, y: 0), to: view)
        let topRightPoint = myView.convert(CGPoint(x: myView.bounds.width, y: 0), to: view)

        // Draw new lines
        line1 = drawLine(from: attachmentBehaviors[0].anchorPoint, to: topLeftPoint)
        line2 = drawLine(from: attachmentBehaviors[1].anchorPoint, to: topRightPoint)

        // Add the new lines to the view
        view.layer.addSublayer(line1!)
        view.layer.addSublayer(line2!)
    }


    
    func drawLine(from startPoint: CGPoint, to endPoint: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        let line = CAShapeLayer()
        line.path = path.cgPath
        line.strokeColor = UIColor.black.cgColor
        line.lineWidth = 2.0
        return line
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            let locationInView = gesture.location(in: myView)
            let offset = UIOffset(horizontal: locationInView.x - myView.bounds.midX, vertical: locationInView.y - myView.bounds.midY)
            dragBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: offset, attachedToAnchor: gesture.location(in: view))
            animator.addBehavior(dragBehavior!)
        }
        else if gesture.state == .changed {
            let locationInSuperview = gesture.location(in: view)
            let distance = sqrt(pow(myView.center.x - locationInSuperview.x, 2) + pow(myView.center.y - locationInSuperview.y, 2))
            if distance <= initialDistance {
                dragBehavior?.anchorPoint = locationInSuperview
            }
        }
        else if gesture.state == .ended || gesture.state == .cancelled {
            if let drag = dragBehavior {
                animator.removeBehavior(drag)
                dragBehavior = nil
            }
        }
    }


    func executeLogic() {
        Background.shared.changeZoom(newScale: 2.8, newX: 150, newY: 200, duration: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 1, animations: {
                self.myView.alpha = 1
            })
        }
    }

    func teardownView() {
        myView.removeFromSuperview()
        animator = nil
        gravity = nil
        attachmentBehaviors.forEach { animator.removeBehavior($0) }
        attachmentBehaviors.removeAll()
        attachmentViews.forEach { $0.removeFromSuperview() }
        attachmentViews.removeAll()
        
        
        
        // Stop the display link
        displayLink?.invalidate()
        displayLink = nil
        
        line1?.removeFromSuperlayer()
        line2?.removeFromSuperlayer()
    }

    deinit {
        print("\(self) is being deallocated")
    }
}

