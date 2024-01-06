//
//  ExplainVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 31/07/2023.
//

import UIKit

class ExplainVC: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    let view: UIView
    
        var outerWindow: UIVisualEffectView
    var innerWindow: UIVisualEffectView
    
    var titleLabel: UILabel
    var label: UILabel
    var typingWorkItem: DispatchWorkItem?
    var typingFrequency: CGFloat = 0.02
    var speedFactor: CGFloat = 6
    
    let padding: CGFloat = 10
    var bottomPadding: CGFloat {
        return TopBarManager.shared.topBar.frame.height + padding * 4
    }
    
    let cornerRadius: CGFloat = 20
    
    var gifView: UIImageView
    var state: State = .stage0
    var nextButton: CustomNextButton!  //NextButton
    var progressMeter: ProgressMeter
    
    var  tapGesture: UITapGestureRecognizer
    var typingTimer: Timer?
    var finishedPrinting: Bool = false
    var isLastScreen: Bool = false
    
    var innerFrameAlpha: CGFloat = 1
    var outerFrameAlpha: CGFloat = 0.8
    
    
    
    init(view: UIView) {
        self.view = view
        outerWindow = UIVisualEffectView(effect: UIBlurEffect(style: .light))

        self.outerWindow.alpha = 0
        self.outerWindow.layer.cornerRadius = cornerRadius
        self.outerWindow.clipsToBounds = true
        self.outerWindow.translatesAutoresizingMaskIntoConstraints = false
        self.outerWindow.effect = nil
        
        self.innerWindow = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        self.innerWindow.alpha = 0
        self.innerWindow.layer.cornerRadius = cornerRadius / 1.5
        self.innerWindow.clipsToBounds = true
        self.innerWindow.translatesAutoresizingMaskIntoConstraints = false
        

        self.titleLabel = UILabel()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 1
        self.titleLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/32,weight: .bold)
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
        self.label = UILabel()
        self.label.numberOfLines = 0
        self.label.adjustsFontSizeToFitWidth = true  // automatically adjust font size to fit width
        self.label.minimumScaleFactor = 0.5  // minimum scale factor for the font size, adjust as needed
        self.label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.height/53 )  // increase font size as needed
        self.label.textColor = .black
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the UIImageView
        self.gifView = UIImageView()
        self.gifView.translatesAutoresizingMaskIntoConstraints = false
        self.gifView.layer.cornerRadius = cornerRadius
        self.gifView.layer.masksToBounds = true
        self.gifView.contentMode = .scaleAspectFit
        
        
        
        let image = UIImage(named: "seaOfData")
        gifView.image = image
        
        self.progressMeter = ProgressMeter()
        
        self.tapGesture = UITapGestureRecognizer()
        self.nextButton = CustomNextButton(behavior: ScaleBehavior()) //NextButton()

        
        self.tapGesture.addTarget(self, action: #selector(didTapInnerWindow))
        innerWindow.addGestureRecognizer(tapGesture)
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        
    }
    
    func shouldPerformTypingAnimation() -> Bool {
           return false  // By default, typing animation is enabled
       }
    
    func setTitlesForState(_ state: State) {
            switch state {
            case .stage0:
                titleLabel.text = "Title for Stage 0"
                nextButton.setTitle("Next for Stage 0", for: .normal)
                // Set titles for other UI elements or do additional configuration based on this state
            case .stage1:
                titleLabel.text = "Title for Stage 1"
                nextButton.setTitle("Next", for: .normal)
                // Set titles for other UI elements or do additional configuration based on this state
            case .stage2:
                titleLabel.text = "Title for Stage 2"
                nextButton.setTitle("Next", for: .normal)
                // Set titles for other UI elements or do additional configuration based on this state
            case .stage3:
                titleLabel.text = "Title for Stage 3"
                nextButton.setTitle("I'm Ready!", for: .normal)
                // Set titles for other UI elements or do additional configuration based on this state
            case .finished:
                titleLabel.text = "Title for Finished Stage"
                nextButton.setTitle("", for: .normal)
                // Set titles for other UI elements or do additional configuration based on this state
            }
        }
    
    // Override these in subclasses
    func textForState(_ state: State) -> String {
        return ""
    }
    
    func imageForState(_ state: State) -> UIImage? {
        return nil
    }
    
    func changeZoomToCurrentExplain(){
        
    }
    
    func labelForStage()-> String {
        return ""
    }
    
    func advanceToNextVC(){}
    
    func setupView() {
        view.addSubview(outerWindow)
        view.addSubview(innerWindow)
        view.addSubview(gifView)
        innerWindow.contentView.addSubview(titleLabel)
        innerWindow.contentView.addSubview(label)
        view.addSubview(nextButton)
        view.addSubview(progressMeter)
        
        label.textAlignment = .center
        
        NSLayoutConstraint.activate([
            //            outerWindow.topAnchor.constraint(equalTo: view.topAnchor, constant: bottomPadding),
            outerWindow.topAnchor.constraint(equalTo: TopBarManager.shared.topBar.bottomAnchor, constant: 2*padding),
            outerWindow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding*2),
            outerWindow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding*2),
            outerWindow.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomPadding),
            innerWindow.centerXAnchor.constraint(equalTo: outerWindow.centerXAnchor),
            innerWindow.centerYAnchor.constraint(equalTo: outerWindow.centerYAnchor),
            innerWindow.widthAnchor.constraint(equalTo: outerWindow.widthAnchor, constant: -padding*2),
            innerWindow.heightAnchor.constraint(equalTo: outerWindow.heightAnchor, constant:  -padding*2)
        ])
        
        NSLayoutConstraint.activate([
            gifView.topAnchor.constraint(equalTo: innerWindow.contentView.topAnchor, constant: padding*2),
            gifView.leadingAnchor.constraint(equalTo: innerWindow.contentView.leadingAnchor, constant: padding*2),
            gifView.trailingAnchor.constraint(equalTo: innerWindow.contentView.trailingAnchor, constant: -padding*2),
        ])
        
        gifView.widthAnchor.constraint(equalTo: innerWindow.contentView.widthAnchor, constant: (-4)*padding).isActive = true
        gifView.heightAnchor.constraint(equalTo: innerWindow.contentView.widthAnchor, constant: (-4)*padding).isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: gifView.bottomAnchor, constant: 2*padding),
            titleLabel.leadingAnchor.constraint(equalTo: innerWindow.contentView.leadingAnchor, constant: 4*padding),
            titleLabel.trailingAnchor.constraint(equalTo: innerWindow.contentView.trailingAnchor, constant: (-6)*padding),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2 * padding),
            label.leadingAnchor.constraint(equalTo: innerWindow.contentView.leadingAnchor, constant: 2 * padding),
            label.trailingAnchor.constraint(equalTo: innerWindow.contentView.trailingAnchor, constant: -4 * padding), // Adjusted trailing constant
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.7), // 80% of superview width
            
        ])

        
        
       
        NSLayoutConstraint.activate([
            //nextButton.centerXAnchor.constraint(equalTo: outerWindow.centerXAnchor),
            nextButton.trailingAnchor.constraint(equalTo: innerWindow.trailingAnchor), //constant: -padding*1),
            nextButton.topAnchor.constraint(equalTo: outerWindow.bottomAnchor, constant: padding*3),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*6),
            //nextButton.widthAnchor.constraint(equalToConstant: 120),
            //nextButton.heightAnchor.constraint(equalToConstant: 60)

        ])
        
        NSLayoutConstraint.activate([
            //nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor)
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant:TopBarManager.shared.topBar.frame.height/2)


        ])
        
        progressMeter.centerYAnchor.constraint(equalTo: innerWindow.contentView.bottomAnchor, constant: -padding*2).isActive = true
        progressMeter.centerXAnchor.constraint(equalTo: innerWindow.centerXAnchor).isActive = true
       
    // Add swipe gesture recognizer to innerWindow
        innerWindow.isUserInteractionEnabled = true
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRightGesture.direction = .right
        innerWindow.addGestureRecognizer(swipeRightGesture)

        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = .left
        innerWindow.addGestureRecognizer(swipeLeftGesture)
    }
    
    func teardownView() {
        self.typingWorkItem?.cancel() // cancel the work item to stop the typing effect
        self.label.removeFromSuperview()
        self.titleLabel.removeFromSuperview()
        self.gifView.removeFromSuperview()
        self.innerWindow.removeFromSuperview()
        self.outerWindow.removeFromSuperview()
        self.nextButton.removeFromSuperview()
        self.progressMeter.removeFromSuperview()
    }
    
    func advanceState() {
        progressMeter.nextStage()
        self.label.alpha = 1
        self.gifView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.gifView.alpha = 1
            self.titleLabel.alpha = 1
            
        })
        state = state.nextState
        gifView.image = imageForState(state)
        titleLabel.text = labelForStage()
        typeText(text: textForState(state)) {
            self.finishedPrinting = true
            //self.animateNextButton()
        }
        // Hide the "next" button while the animation is playing
        nextButton.isHidden = false
    }
    
    
    @objc func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .left {
            // Swipe left, move to the next state
            advanceState()
            if state == .finished {
                // Transition to the next view controller
                advanceToNextVC()
            }
        } else if recognizer.direction == .right {
            if state != .stage1 {
                goBackState()
            }
            // Swipe right, move to the previous state (if needed)
            // Implement logic to go back to the previous state if necessary
        }
    }
    
    func goBackState() {
        progressMeter.prevStage()
        state = state.previousState
        gifView.image = imageForState(state)
        titleLabel.text = labelForStage()
        label.text = textForState(state)
        self.finishedPrinting = true
        self.nextButton.isHidden = false
        

    }
    
    func executeLogic() {
        // Add your logic here
        print("Starting logic of WindowVC")
        changeZoomToCurrentExplain()
        UIView.animate(withDuration: 1, animations: { [self] in
            innerWindow.alpha = innerFrameAlpha
            outerWindow.alpha = outerFrameAlpha
        })
        advanceState()
    }
    
    deinit {
        print("\(self) is being deallocated")
    }
    
    @objc func nextButtonPressed() {
        print("Current state: \(state)")
        // When the "next" button is pressed, advance to the next state
        if state == .stage3 {
            UIView.animate(withDuration: 1, animations: {
                self.innerWindow.alpha = 0
                self.outerWindow.alpha = 0
                self.progressMeter.alpha = 0
            }, completion: { _ in
                self.advanceToNextVC()
            })
            if isLastScreen {
                nextButton.setTitle("I'm Ready!", for: .normal)
            }
        }else{
            Background.shared.changeZoom(moveRight: 20, duration: 2, delay: 0, options: .curveEaseInOut)
        }
        UIView.animate(withDuration: 1, animations: {
            self.nextButton.alpha = 0
            self.gifView.alpha = 0
            self.titleLabel.alpha = 0.3
            self.label.alpha = 0
            
        }, completion: { _ in
            self.advanceState()
        })
    }
    
    func typeText(text: String, completion: @escaping () -> Void) {
        finishedPrinting = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14
        
        if shouldPerformTypingAnimation() {
            

            
            label.text = "" // make sure the label starts with an empty string
            
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text.count))
            
            var characterIndex = 0
            var delay: CGFloat = 0.0
            
            typingTimer = Timer.scheduledTimer(withTimeInterval: Double(typingFrequency), repeats: true) { [self] timer in
                guard characterIndex < text.count else {
                    timer.invalidate()
                    completion()
                    return
                }
                
                let character = text[text.index(text.startIndex, offsetBy: characterIndex)]
                self.label.text?.append(character)
                
                if character == "," {
                    delay = self.typingFrequency * self.speedFactor
                } else if character == "." {
                    delay = self.typingFrequency * (self.speedFactor * 2)
                } else if character == "\n" {
                    delay = self.typingFrequency * (self.speedFactor * 4)
                } else {
                    delay = self.typingFrequency * CGFloat(arc4random_uniform(2))  // random delay for natural typing
                }
                
                timer.fireDate = Date().addingTimeInterval(Double(typingFrequency + delay))
                characterIndex += 1
            }
                
        } else {
            label.text = text
            completion()
            animateNextButton()
            return

            

            
        }

        
    }
    
    func boldText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.font: UIFont.boldSystemFont(ofSize: 16)], range: NSRange(location: 0, length: text.count))
        return attributedString
    }
    
    @objc func didTapInnerWindow() {
        if finishedPrinting {
            return
        }
        finishedPrinting = true
        typingTimer?.invalidate()  // Stop the timer
        label.text = textForState(state)  // Set the label text to the full text for the current state
        
        
        animateNextButton()
    }
    
    private func animateNextButton(){
        self.nextButton.alpha = 0
        self.nextButton.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            UIView.animate(withDuration: 0.5) {
                self?.nextButton.alpha = 1
            }
        }
    }
}


enum State {
    case stage0
    case stage1
    case stage2
    case stage3
    case finished
    var isLastScreen: Bool {
        return self == .finished
    }
    
    var nextState: State {
        switch self {
        case .stage0: return .stage1
        case .stage1: return .stage2
        case .stage2: return .stage3
        case .stage3, .finished: return .finished
        }
    }
    var previousState: State {
        switch self {
        case .stage0: return .stage0 // If you can't go further back from stage0
        case .stage1: return .stage0
        case .stage2: return .stage1
        case .stage3: return .stage2
        case .finished: return .stage3
        }
    }
}

/**
 
 case .stage1: return "In an age where personal data is the new currency, technology companies scrutinize our every move. They claim to know our desires, but more often than not, their bottom line takes precedence over our true needs. "
 
 case .stage2: return "Enter reCollect, your beacon in this sea of data exploration. We're pioneering a different kind of research, one that delves into the heart of what truly matters in human experiences. "
 
 case .stage3: return "Ever wonder why some moments urge you to reach for your mobile device, while others pass unnoticed? With reCollect, we ponder this enigma. We believe that in the midst of countless daily experiences, the moments you choose to capture hold profound significance. Let's delve into that together! "
 */
