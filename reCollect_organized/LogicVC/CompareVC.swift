//
//  CompareVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 07/09/2023.
//
import UIKit
import Photos


    
class CompareVC: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?

    let view: UIView
    
    private var domains: [Domain] = [.recency, .frequency, .significance1, .significance2, .significance3, .significance4, .selfrelevance, .emotional, .aesthetics, .vividness]
    
    private var currentDomainIndex: Int = 0

    private var timer: Timer?
    private var startTime: Date?
    private var elapsedTime: TimeInterval = 0
    var responseTime: TimeInterval?


    private let explainCardButton: UIButton = UIButton(type: .custom)
    
    private let button1: ImageFillingButton = ImageFillingButton()
    private let button2: ImageFillingButton = ImageFillingButton()

    private var behavior: ButtonBehavior = ScaleBehaviorBigObj()
    
    let padding: CGFloat = UIScreen.main.bounds.width / 20
    
    let tapHintLabel = UILabel()
    
    var randomPhotoCouples: [[String]] = []
    var indexComparison:Int = 0
    
    
    var buttonSize: CGFloat!
    let vsLabel = UILabel()
    let vsBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var comparisonQuestion: String!
    var comparisonLabel = UILabel()



    let comparisonsInDomain:Int = 1
    
    init(view: UIView) {
        self.view = view
        setImageDims()
//        DataSet.shared.randomImagesForDataset(numOfPhotos: 100)

    }
    
    func setupView() {
        // Setup explainCardButton
        setVsLabel()
        
        behavior.apply(to: explainCardButton)
        behavior.apply(to: button1)
        behavior.apply(to: button2)
        
        explainCardButton.addTarget(self, action: #selector(explainCardTapped), for: .touchUpInside)
        explainCardButton.isUserInteractionEnabled = false
        explainCardButton.adjustsImageWhenHighlighted = false
        explainCardButton.alpha = 0.0
        view.addSubview(explainCardButton)
        // Add constraints and positioning for explainCardButton
        
        let currentDomain = domains[currentDomainIndex]
        let image = UIImage(named: currentDomain.svgFileName)
        explainCardButton.setImage(image, for: .normal)
        
        explainCardButton.translatesAutoresizingMaskIntoConstraints = false
        explainCardButton.imageView?.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            explainCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            explainCardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            explainCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * padding),
            explainCardButton.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -2 * padding)
        ])
        
        tapHintLabel.text = "Tap above to continue!"
        tapHintLabel.textColor = .gray
        tapHintLabel.textAlignment = .center
        tapHintLabel.alpha = 0.0  // Initially hidden
        view.addSubview(tapHintLabel)
        
        // Set constraints
        tapHintLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tapHintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tapHintLabel.topAnchor.constraint(equalTo: explainCardButton.imageView!.bottomAnchor, constant: 10)
        ])
        
//        button1.addTarget(self, action: #selector(compareButtonTapped),  for: .touchUpInside)
//        button2.addTarget(self, action: #selector(compareButtonTapped),  for: .touchUpInside)
        button1.addTarget(self, action: #selector(compareButtonTapped(sender:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(compareButtonTapped(sender:)), for: .touchUpInside)

        
        // Setup button1 and button2
        button1.isUserInteractionEnabled = false
        button2.isUserInteractionEnabled = false
        button1.adjustsImageWhenHighlighted = false
        button2.adjustsImageWhenHighlighted = false
        
        button1.imageView?.contentMode = .scaleAspectFill
        button1.clipsToBounds = true
        button1.layer.cornerRadius = 20
//        button1.contentEdgeInsets = .zero
//        button1.imageEdgeInsets = .zero
        
        button2.imageView?.contentMode = .scaleAspectFill
        button2.clipsToBounds = true
        button2.layer.cornerRadius = 20

//        button2.contentEdgeInsets = .zero
//        button2.imageEdgeInsets = .zero
        
        button1.alpha = 0
        button2.alpha = 0
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(vsBlurView)
        view.addSubview(vsLabel)
        view.addSubview(comparisonLabel)
    }
    
    func teardownView() {
        explainCardButton.removeFromSuperview()
        button1.removeFromSuperview()
        button2.removeFromSuperview()
    }
    
    func executeLogic() {
        Background.shared.changeZoom(newScale: 2.8, newX: 10, newY: -20, duration: 1){
            self.displayCurrentDomain()
        }
    }
    
    deinit {
        print("\(self) is being deallocated")
    }
    
    /**
     Class functions:
     */
    @objc private func updateElapsedTime() {
        elapsedTime += 0.1
        // You can update any UI elements here if needed
    }
    
 




    
    private func displayCurrentDomain() {
        guard currentDomainIndex < domains.count else {
            // Handle end of domains if needed
            return
        }
        fillRandomPhotoCouples()
        let currentDomain = domains[currentDomainIndex]
        let image = UIImage(named: currentDomain.svgFileName)
        comparisonQuestion = currentDomain.caption
        explainCardButton.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.5, animations: { [self] in
            explainCardButton.alpha = 1.0
        }) { [self] _ in
            explainCardButton.isUserInteractionEnabled = true
            
            // Begin the label animation after the button is shown
            animateHintLabel()

        }
    }
    
    @objc private func explainCardTapped() {
        explainCardButton.isUserInteractionEnabled = false
        tapHintLabel.layer.removeAllAnimations()  // Stop all animations on the label and hide it
        let labelOpacity = self.tapHintLabel.alpha
        UIView.animate(withDuration: labelOpacity, animations: {
            self.tapHintLabel.alpha = 0.0
        }){_ in
            UIView.animate(withDuration: 0.5, animations: {
                self.explainCardButton.alpha = 0.0
            }){_ in
                self.setNewComp()
                self.setQuestionLabel()
                self.setBlurrEffects()
                self.animateQuestionLabel()
            }
        }
    }
    
    @objc private func compareButtonTapped(sender: UIButton) {

        
        button1.isUserInteractionEnabled = false
        button2.isUserInteractionEnabled = false
        
        // Calculate the elapsed time
        let responseTime = Date().timeIntervalSince(startTime!)

        
        if sender === button1 {
            FirebaseManager.shared.savePhotoComparison(domain: domains[currentDomainIndex], more: randomPhotoCouples[indexComparison][0], less: randomPhotoCouples[indexComparison][1], responseTime: responseTime, totalTime: elapsedTime)
        }
        else if sender === button2 {
            FirebaseManager.shared.savePhotoComparison(domain: domains[currentDomainIndex], more: randomPhotoCouples[indexComparison][1], less: randomPhotoCouples[indexComparison][0], responseTime: responseTime, totalTime: elapsedTime)
            
            // Print the timing for debugging
            print("Response Time: \(responseTime) seconds")
            //print("Total Time: \(elapsedTime) seconds")

            

        }

        UIView.animate(withDuration: 0.5 , animations: { [self] in
            button1.alpha = 0
            button2.alpha = 0
            vsLabel.alpha = 0
        }){ [self]_ in
            if indexComparison < (comparisonsInDomain-1){
                indexComparison += 1
                setNewComp()
            }
            else{
                if( currentDomainIndex == domains.count-1){
                    completeCompareTask()
                }
                else {
                    indexComparison = 0
                    currentDomainIndex += 1
                    displayCurrentDomain()
                }
            }
            startTimer()
        }
    }
    
    private func setNewComp(){
        // Start the timer for the new comparison

        setNewimages()
        // Set button frame for button1 - before animation
        let button1Xoffset = (UIScreen.main.bounds.width - buttonSize) / 2 - 100 // Centered on x-axis
        let button1Y = (UIScreen.main.bounds.height / 2) - buttonSize - padding // Spacing above the center
        button1.frame = CGRect(x: button1Xoffset, y: button1Y, width: buttonSize, height: buttonSize)
        
        // Set button frame for button2
        let button2Xoffset = (UIScreen.main.bounds.width - buttonSize) / 2 + 100 // Centered on x-axis
        let button2Y = UIScreen.main.bounds.height / 2 + padding // Spacing below the center
        button2.frame = CGRect(x: button2Xoffset, y: button2Y, width: buttonSize, height: buttonSize)
        
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
//            vsBlurView.alpha = 1
            vsLabel.alpha = 1
        }){_ in
            self.button1.isUserInteractionEnabled = true
            self.button2.isUserInteractionEnabled = true
        }
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            // Update the elapsed time every second
            self?.responseTime = self?.responseTime ?? 0 + 1
        }
    }
    
    private func completeCompareTask() {
        // Fade out button1 and button2
        // Update currentDomainIndex and display the next domain's explainCardButton
    }
    
    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            // Update the elapsed time every second
            self?.elapsedTime = self?.elapsedTime ?? 0 + 1

        }
    }
    
    private func setImageDims(){
        let maxWidth = UIScreen.main.bounds.width - 2 * padding
        let maxHeight = (UIScreen.main.bounds.height / 2) - TopBarManager.shared.topBar.frame.height - 2 * padding
        
        // Determine button size
        buttonSize = min(maxWidth, maxHeight)
    }
    
    private func animateHintLabel() {
        tapHintLabel.alpha = 0.0 // Ensure the label starts from hidden state
        UIView.animate(withDuration: 1, delay: 0.0, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
            self.tapHintLabel.alpha = 1.0
        }, completion: nil)
    }
    
    private func setVsLabel(){
        vsLabel.text = "Vs."
        vsLabel.textAlignment = .center
//        vsLabel.frame = vsBlurView.bounds  // Make the label fill the blur view
        vsLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold) // may be adjusted to different phones
        vsLabel.sizeToFit()
        vsLabel.alpha = 0
    }
    
//    private func setQuestionLabel(){
//        comparisonLabel.text = comparisonQuestion
//        comparisonLabel.textAlignment = .center
//        comparisonLabel.frame = CGRect(x: button2.frame.minX,
//                                       y: button2.frame.maxY + padding*2,
//                                       width: button2.frame.width,
//                                       height: view.frame.maxY - button2.frame.maxY - padding*4 )
//        comparisonLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold) // may be adjusted to different phones
//        comparisonLabel.sizeToFit()
//        comparisonLabel.alpha = 0
//
//    }
    
    private func adjustFontSizeToFit(label: UILabel, frame: CGRect) {
        guard let text = label.text else { return }
        
        let font = label.font
        var fontSize = font?.pointSize
        let minFontSize: CGFloat = 10 // The minimum font size you want to allow
        
        // Measure text with the font and check if it fits the frame
        while fontSize! >= minFontSize {
            let size = text.size(withAttributes: [NSAttributedString.Key.font: font!.withSize(fontSize!)])
            if size.width <= frame.width && size.height <= frame.height {
                break
            }
            fontSize! -= 1.0
        }
        
        label.font = font!.withSize(fontSize!)
    }

    private func setQuestionLabel() {
        comparisonLabel.text = comparisonQuestion
        comparisonLabel.textAlignment = .left
        comparisonLabel.numberOfLines = 0
        comparisonLabel.lineBreakMode = .byWordWrapping
        let desiredFrame = CGRect(
            x: button2.frame.minX,
            y: button2.frame.maxY + padding*2,
            width: button2.frame.width,
            height: view.frame.maxY - button2.frame.maxY - padding*4
        )
        comparisonLabel.frame = desiredFrame
        comparisonLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        comparisonLabel.alpha = 0
        
        adjustFontSizeToFit(label: comparisonLabel, frame: desiredFrame)
    }



    
    private func animateQuestionLabel(){
//        let centerX = UIScreen.main.bounds.width / 2
//        let viewFrameMAxY = view.frame.maxY
//        
//        let button2height = comparisonLabel.frame.height
//        let centerY = button2.frame.maxY + ((view.frame.maxY - button2.frame.maxY)/2)
//        comparisonLabel.center = CGPoint(x: centerX, y: centerY)
        UIView.animate(withDuration: 1, animations: { [self] in
            vsBlurView.alpha = 1
            comparisonLabel.alpha = 1
        })
    }
    
    private func animateBlurEffect(){
        
    }
   
    
    private func setBlurrEffects(){
        // Configure the blur view
        vsBlurView.frame = comparisonLabel.frame
        vsBlurView.center = comparisonLabel.center
        vsBlurView.layer.cornerRadius = vsBlurView.frame.height/6
        vsBlurView.clipsToBounds = true
        vsBlurView.alpha = 0  // Initially hidden
    }
    
    
    
    private func setNewimages(){
        if let image1 = DataSet.shared.approvedPhotosData[randomPhotoCouples[indexComparison][0]]?.image {
            button1.setImage(image1, for: .normal)
        }
        
        if let image2 = DataSet.shared.approvedPhotosData[randomPhotoCouples[indexComparison][1]]?.image {
            button2.setImage(image2, for: .normal)
            

        }
        
    }
    
//    private func fetchImage(for localIdentifier: String) -> UIImage? {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.fetchLimit = 1
//        let result = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: fetchOptions)
//        
//        guard let asset = result.firstObject else { return nil }
//        
//        var fetchedImage: UIImage?
//        let manager = PHImageManager.default()
//        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
//        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, _) in
//            fetchedImage = image
//        }
//        
//        return fetchedImage
//    }
    
    private func fillRandomPhotoCouples() {
        randomPhotoCouples.removeAll() // Clear any existing data
        
        let allPhotoLocations = Array(DataSet.shared.approvedPhotosData.keys)
        
        // Ensure there are enough photos to create couples
        guard allPhotoLocations.count >= 2 else { return }
        
        var availablePhotoLocations = allPhotoLocations
        
        for _ in 1...comparisonsInDomain {
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
        if firstIndex > secondIndex {
            return (secondIndex, firstIndex)
        }
        return (firstIndex, secondIndex)
    }
    
  
}

class ImageFillingButton: UIButton {
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect
    }
}


