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
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var shuffledDomains: [Domain] = []
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
    
    var cardTapped = false
    var buttonSize: CGFloat!
    let vsLabel = UILabel()
    let vsBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    var comparisonQuestion: String!
    var comparisonLabel = UILabel()
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)

        // Set additional properties and add target-action as needed
        return button
    }()



    let comparisonsInDomain:Int = 10
    
    init(view: UIView) {
        self.view = view
        setImageDims()
//        DataSet.shared.randomImagesForDataset(numOfPhotos: 100)
        shuffleDomainsForUser()

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
        skipButton.addTarget(self, action: #selector(compareButtonTapped(sender:)), for: .touchUpInside)

        
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
    
    func setFinalImage(_ image: UIImage?) {
        let finalImageView = UIImageView()
        finalImageView.contentMode = .scaleAspectFit
        finalImageView.image = image
        
        finalImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finalImageView)
        
        // Add constraints to position the final image view
        NSLayoutConstraint.activate([
            finalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            finalImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * padding),
            finalImageView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -2 * padding)
        ])
    }

    private func shuffleDomainsForUser() {
        shuffledDomains = domains.shuffled()
        // Use 'shuffledDomains' for the current user session
        print("Shuffled domains for this user session: \(shuffledDomains)")
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
        guard currentDomainIndex < shuffledDomains.count else {
            // Handle end of domains if needed
            return
        }

        fillRandomPhotoCouples()
        let currentDomain = shuffledDomains[currentDomainIndex]
        let image = UIImage(named: currentDomain.svgFileName)
        comparisonQuestion = currentDomain.caption
        explainCardButton.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.5, animations: { [self] in
            explainCardButton.alpha = 1.0
            skipButton.alpha = 0.0 // Hide skipButton
            comparisonLabel.alpha = 0.0 // Hide comparisonLabel
            vsBlurView.alpha = 0
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
                //self.setBlurrEffects()
                self.animateQuestionLabel()
                self.cardTapped = true
                
            }
        }
    }
    
    @objc private func compareButtonTapped(sender: UIButton) {

        
        button1.isUserInteractionEnabled = false
        button2.isUserInteractionEnabled = false
        
        // Calculate the elapsed time
        let responseTime = Date().timeIntervalSince(startTime!)
        
        if let significance1 = DataSet.shared.approvedPhotosData[randomPhotoCouples[indexComparison][0]]?.significanceValue,
            let significance2 = DataSet.shared.approvedPhotosData[randomPhotoCouples[indexComparison][1]]?.significanceValue {
            print("Comparing images with significance levels: \(significance1) against \(significance2)")
        }
        if sender === skipButton {
            if indexComparison < randomPhotoCouples.count {
                let skippedPair = randomPhotoCouples[indexComparison]
                FirebaseManager.shared.savePhotoComparison(domain: domains[currentDomainIndex], more: skippedPair[0], less: skippedPair[1], responseTime: responseTime, isSkipped: true)
                fillRandomPhotoCouples(excludePair: skippedPair)
            }
            setNewComp()
            return
        }
            
        /*if sender === skipButton {
            if indexComparison < randomPhotoCouples.count {
                let skippedPair = randomPhotoCouples[indexComparison]
                fillRandomPhotoCouples(excludePair: skippedPair)
            }
            setNewComp()
            return

        }*/
        else if sender === button1 {
            FirebaseManager.shared.savePhotoComparison(domain: domains[currentDomainIndex], more: randomPhotoCouples[indexComparison][0], less: randomPhotoCouples[indexComparison][1], responseTime: responseTime)
        }
        else if sender === button2 {
            FirebaseManager.shared.savePhotoComparison(domain: domains[currentDomainIndex], more: randomPhotoCouples[indexComparison][1], less: randomPhotoCouples[indexComparison][0], responseTime: responseTime)
            
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

        setNewimages()
  
        // Set button frame for button1 - before animation
        let button1Xoffset = (UIScreen.main.bounds.width - buttonSize) / 2 - 100 // Centered on x-axis
        let button1Y = (UIScreen.main.bounds.height / 2) - buttonSize +  (0.5 * padding) // Spacing above the center
        button1.frame = CGRect(x: button1Xoffset, y: button1Y, width: buttonSize, height: buttonSize)
        
        // Set button frame for button2
        let button2Xoffset = (UIScreen.main.bounds.width - buttonSize) / 2 + 100 // Centered on x-axis
        let button2Y = UIScreen.main.bounds.height / 2 + ( 2.5 * padding) // Spacing below the center
        button2.frame = CGRect(x: button2Xoffset, y: button2Y, width: buttonSize, height: buttonSize)
        
        // Position the label at the center of the screen
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height / 2
        vsLabel.center = CGPoint(x: centerX, y: (button1.frame.maxY + button2.frame.minY) / 2)
        
            
        let button1X = (UIScreen.main.bounds.width - buttonSize) / 2
        let button2X = (UIScreen.main.bounds.width - buttonSize) / 2
        UIView.animate(withDuration: 0.5, animations: { [self] in
            button1.frame = CGRect(x: button1X, y: button1Y, width: buttonSize, height: buttonSize)
            button2.frame = CGRect(x: button2X, y: button2Y, width: buttonSize, height: buttonSize)
            button1.alpha = 1
            button2.alpha = 1
//            vsBlurView.alpha = 1
            vsLabel.alpha = 1
            skipButton.alpha = 1.0 // Show skipButton
            comparisonLabel.alpha = 1.0 // Show comparisonLabel
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
        // Fade out button1 and button2 if needed
        UIView.animate(withDuration: 0.5, animations: {
            self.button1.alpha = 0
            self.button2.alpha = 0
            self.comparisonLabel.alpha = 0
            self.skipButton.alpha = 0
            self.vsBlurView.alpha = 0
        }) { [weak self] _ in
            guard let self = self else { return }

            // Handle the completion of all domains
            if self.currentDomainIndex == self.shuffledDomains.count - 1 {
                // Add the final image in the center of the screen
                let finalImage = UIImage(named: "final") // Replace "finalImage" with your image name
                self.setFinalImage(finalImage)
                let finalImageViewBottomY = (self.view.center.y + 100)

                
            // Create two separate labels for two lines of text
            let linkLabel1 = UILabel()
            linkLabel1.textAlignment = .center
            linkLabel1.numberOfLines = 0
            linkLabel1.textColor = .blue
            linkLabel1.isUserInteractionEnabled = true
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(openFirstLink))
            linkLabel1.addGestureRecognizer(tapGesture1)
            
            let linkLabel2 = UILabel()
            linkLabel2.textAlignment = .center
            linkLabel2.numberOfLines = 0
            linkLabel2.textColor = .blue
            linkLabel2.isUserInteractionEnabled = true
            let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(openSecondLink))
            linkLabel2.addGestureRecognizer(tapGesture2)
            
            // Set the text for both labels with attributed strings
            let attributedText1 = NSMutableAttributedString()
            attributedText1.append(NSAttributedString(string: "Link to TIPI questionnaire\n", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]))
            linkLabel1.attributedText = attributedText1
    
            let attributedText2 = NSMutableAttributedString()
            attributedText2.append(NSAttributedString(string: "Link to User Experience feedback", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]))
            linkLabel2.attributedText = attributedText2
            
            linkLabel1.attributedText = attributedText1
            linkLabel2.attributedText = attributedText2
            
            // Set frame and position for both labels
            let labelHeight: CGFloat = 30 // Height of each label
            linkLabel1.frame = CGRect(x: 0, y: finalImageViewBottomY + (padding*6) , width: self.view.bounds.width, height: labelHeight)
            linkLabel2.frame = CGRect(x: 0, y: linkLabel1.frame.maxY, width: self.view.bounds.width, height: labelHeight)
            
            // Add both labels to the view
            self.view.addSubview(linkLabel1)
            //self.view.addSubview(linkLabel2)
        } else {
            // Increment to the next domain and display its explainCardButton
            self.currentDomainIndex += 1
            self.displayCurrentDomain()
            }
        }

    }
    
    @objc private func openFirstLink() {
        // Open the first link
        if let url = URL(string: "https://forms.gle/b8gB9YVPJfQa9n8L6") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func openSecondLink() {
        // Open the second link
        if let url = URL(string: "https://forms.gle/15ibvPFRDxgX6ZQu6") {
            UIApplication.shared.open(url)
        }
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
        vsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular) // may be adjusted to different phones
        vsLabel.sizeToFit()
        vsLabel.alpha = 0


        // Set vsLabel's center y-coordinate
        let vsLabelY = (button1.frame.maxY + button2.frame.minY) / 2 + (padding*4.5)

        // Set vsLabel's center
        vsLabel.center = CGPoint(x: view.bounds.midX, y: (button1.frame.maxY + button2.frame.minY) / 2)
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
        /*guard let text = label.text else { return }
        
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
    }*/
        guard let text = label.text else { return }
            
            let font = UIFont.systemFont(ofSize: 16) // Set the font size to 16
            
            // Set the label's font to the calculated font size
            label.font = font
            
            // Set label properties for word wrapping and line break mode
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            
            // Calculate the size of the text with the new font
            let maxSize = CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude)
            let textRect = text.boundingRect(
                with: maxSize,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [NSAttributedString.Key.font: font],
                context: nil
            )
            
            // Check if the text exceeds the frame's bounds
            if textRect.size.height > frame.height {
                label.frame.size.height = textRect.size.height // Adjust label's height to fit text
            }
        }

    private func setQuestionLabel() {
        comparisonLabel.text = comparisonQuestion
        comparisonLabel.textAlignment = .center
        comparisonLabel.numberOfLines = 0
        comparisonLabel.lineBreakMode = .byWordWrapping
        let desiredFrame = CGRect(
            x: button1.frame.minY - 10,
            y: button1.frame.minY - padding*2.8,
            width: button2.frame.width+20, // Adjust the width
            height:   padding * 2.5
            
           )
         /*let desiredFrame = CGRect(
            x: button2.frame.minX,
            y: button2.frame.maxY + padding*2,
            width: button2.frame.width,
            height: view.frame.maxY - button2.frame.maxY - padding*4
            )   */
        
        comparisonLabel.frame = desiredFrame;
        comparisonLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        comparisonLabel.alpha = 0
        
        adjustFontSizeToFit(label: comparisonLabel, frame: desiredFrame)
        

        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = .black
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.layer.cornerRadius = 10
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        skipButton.sizeToFit()
        
        skipButton.frame = CGRect(
            x: view.frame.width - skipButton.frame.width - 70, // Align to the right
            y: screenHeight - (screenHeight - button2.frame.maxY)/2,
            width: skipButton.frame.width + 50,
            height: skipButton.frame.height+10
            )
        let centerY = screenHeight - (screenHeight - button2.frame.maxY) / 2

        // Update the centerY of skipButton while maintaining the x position
        skipButton.center = CGPoint(x: skipButton.center.x, y: centerY)

            

        view.addSubview(skipButton)
    }



    private func setNewCompAndRemovePair() {
        randomPhotoCouples.remove(at: indexComparison)
        setNewComp()
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
    
    private func fillRandomPhotoCouples(excludePair: [String]? = nil) {
        randomPhotoCouples.removeAll() // Clear any existing data
        
        let allPhotoLocations = Array(DataSet.shared.approvedPhotosData.keys)
        
        // Ensure there are enough photos to create couples
        guard allPhotoLocations.count >= 2 else { return }
        
        var availablePhotoLocations = allPhotoLocations
        
        while availablePhotoLocations.count >= 2 {
            guard let location1 = availablePhotoLocations.randomElement() else { break }
            availablePhotoLocations.removeAll { $0 == location1 }
            
            guard let location2 = availablePhotoLocations.randomElement() else { break }
            availablePhotoLocations.removeAll { $0 == location2 }
            
            // Check if the pair is to be excluded
            if let excluded = excludePair, excluded.contains(location1) && excluded.contains(location2) {
                continue // Skip adding the excluded pair
            }
            
            if isValidPair(location1, location2) {
                let couple = [location1, location2]
                randomPhotoCouples.append(couple)
            }
        }
    }

    
    private func isValidPair(_ location1: String, _ location2: String) -> Bool {
        guard let photoData1 = DataSet.shared.approvedPhotosData[location1],
              let photoData2 = DataSet.shared.approvedPhotosData[location2] else {
            return false
        }
        
        let significance1 = photoData1.significanceValue
        let significance2 = photoData2.significanceValue
        
        return !(significance1 == 1 && significance2 == 4) && !(significance1 == 4 && significance2 == 1)
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


