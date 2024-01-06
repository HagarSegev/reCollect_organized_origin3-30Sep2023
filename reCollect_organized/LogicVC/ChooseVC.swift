//
//  ChooseVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 23/07/2023.
//

import UIKit

class ChooseVC: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    let view: UIView
    let BlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    public var framedMemory: FramedMemory!
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    private let xButton = CustomXButton()
    private let vButton = CustomVButton()
    var nextButton: CustomNextButton = CustomNextButton(behavior: ScaleBehavior(), width: UIScreen.main.bounds.width / 3.5, height: TopBarManager.shared.topBar.frame.height/2)
    
    var selectedPhotosCount = 0
    var instructionsLabel = UILabel()
    
    
    init(view: UIView) {
        self.view = view
        
        let image = PhotoLoader.shared.getCurrentPhoto { image, localIdentifier  in
            guard let image = image else {
                print("No image available or access denied.")
                return
            }
            
            DispatchQueue.main.async { [self] in
                self.framedMemory = FramedMemory(image: image, localIdentifier: localIdentifier!, chooseVC: self)
                
                // Add `framedMemory` to your view hierarchy
                self.view.addSubview(self.framedMemory)
                
                self.framedMemory.setupSuperviewConstraints()
                
                UIView.animate(withDuration: 1, animations: {
                    self.framedMemory.alpha = 1
                }){_ in
                    self.framedMemory.startTime = Date()
                    self.setupInstructionsLabel()
                    self.setBlurrEffects()
                    self.animateLabel()
                    
                }
            }
        }
        
    }
    
    
    func setupView() {
        view.addSubview(nextButton)
        view.bringSubviewToFront(nextButton) // Ensure nextButton is in front
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.isUserInteractionEnabled = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:50)
        nextButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: (-10) - TopBarManager.shared.topBar.frame.height/2).isActive = true
        




        createButtons()

        
    }
    

    
    func createButtons() {
        let padding: CGFloat = (nextButton.frame.minX)/2
        print (padding)
        
        // Customize further if needed
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.isUserInteractionEnabled = true
        view.addSubview(xButton)
        xButton.alpha = 1

        // Customize further if needed
        vButton.addTarget(self, action: #selector(vButtonTapped), for: .touchUpInside)
        vButton.translatesAutoresizingMaskIntoConstraints = false
        vButton.isUserInteractionEnabled = true
        view.addSubview(vButton)
        vButton.alpha = 1
        // Add constraints and other properties
        

       
        // Position "x" button to the left side of nextButton
        NSLayoutConstraint.activate([
            xButton.centerXAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -70),
            xButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0) // Adjust the constant to create padding

        ])
        
        // Position "v" button to the right side of nextButton
        NSLayoutConstraint.activate([
            vButton.centerXAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 70),
            vButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor, constant: 0) // Adjust the constant to create padding
        ])
        

    }
    
    @objc func xButtonTapped(_ sender: UIButton) {
        // Call the 'performLeftSwipeAction()' of the 'FramedMemory' instance
        framedMemory.tapLeftBehavior()
    }
    
    @objc func vButtonTapped(_ sender: UIButton) {
        // Call the 'performLeftSwipeAction()' of the 'FramedMemory' instance
        framedMemory.tapRightBehavior()
    }


    
    func teardownView() {
        framedMemory.removeFromSuperview()
        nextButton.removeFromSuperview()
    }
    
    func executeLogic() {
        print("Starting logic of TestLogicVC2")
        Background.shared.changeZoom(newScale: 2, newX: 125, newY: 180, duration: 1) // pisitive: left & up
        UIView.animate(withDuration: 1, animations: {
        })
        print("Finished logic of TestLogicVC2")
    }
    private func setBlurrEffects(){
        // Configure the blur view
        BlurView.frame = instructionsLabel.frame
        BlurView.center = instructionsLabel.center
        BlurView.layer.cornerRadius = BlurView.frame.height/6
        BlurView.clipsToBounds = true
        BlurView.alpha = 0
        view.addSubview(BlurView)
    }
    
    private func animateLabel() {
        UIView.animate(withDuration: 1, animations: { [self] in
            instructionsLabel.alpha = 1
            BlurView.alpha = 1
            // Bring the instructionsLabel to the front
            self.view.bringSubviewToFront(self.instructionsLabel)
        }
        )}
    


    
    func setupInstructionsLabel() {
        let attributedString = NSMutableAttributedString(string: "Swipe ")
        
        // Make "RIGHT" bold with a heavier weight
        let boldFont = UIFont.systemFont(ofSize: 14, weight: .heavy)
        let boldRight = NSMutableAttributedString(string: "RIGHT", attributes: [NSAttributedString.Key.font: boldFont])
        attributedString.append(boldRight)
        
        attributedString.append(NSAttributedString(string: " for photos you like and "))
        
        // Make "LEFT" bold with a heavier weight
        let boldLeft = NSMutableAttributedString(string: "LEFT", attributes: [NSAttributedString.Key.font: boldFont])
        attributedString.append(boldLeft)
        
        attributedString.append(NSAttributedString(string: " for ones you don’t"))
        
        instructionsLabel.attributedText = attributedString
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
        instructionsLabel.lineBreakMode = .byWordWrapping
        instructionsLabel.alpha = 1.0  // Set the initial alpha as needed
        
        // Set up constraints or frame for the label
        instructionsLabel.frame = CGRect(x: 20, y: 115, width: view.bounds.width - 40, height: 45)
        
        // Add the label to the view
        view.addSubview(instructionsLabel)
    }
    
    
    deinit {
        print("\(self) is being deallocated")
    }
    func increaseCount() {
        selectedPhotosCount += 1
    }
    
    func decreaseCount() {
        selectedPhotosCount -= 1
    }
    
    private func removeBlurLabelAndText() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.instructionsLabel.alpha = 0
            self?.BlurView.alpha = 0
        }) { [weak self] _ in
            self?.instructionsLabel.removeFromSuperview()
            self?.BlurView.removeFromSuperview()
        }
    }
    
    @objc func nextButtonTapped() {

        self.framedMemory.behavior.action = nil
        self.framedMemory.prepareForDeallocation()
        removeBlurLabelAndText() // Call the method to remove the blur label and text
        
        
        UIView.animate(withDuration: 1, animations: { [self] in
            self.framedMemory.alpha = 0
            self.nextButton.alpha = 0
            self.xButton.alpha = 0
            self.vButton.alpha = 0
        }) { _ in
            self.delegate?.handler(self, didFinishWithTransitionTo: ExplainRateVC.self)
        }
    }
}


