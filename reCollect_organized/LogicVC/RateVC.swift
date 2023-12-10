//
//  RateVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 29/08/2023.
//

import UIKit
import Photos

class RateVC: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    let view: UIView
    
    private let scrollView = UIScrollView()
    private let nextButton = UIButton()
    private let behavior = ScaleBehaviorBigObj()
    private var approvedPhotos: [ApprovedPhotoData] = Array(DataSet.shared.approvedPhotosData.values)
    private let numberOfColumns = 4
    private let spacing: CGFloat = 5
    private let buttonSize: CGFloat = 50
    
    private var grid: [[UIImageView?]] = []
    private var allFrames: [UIImageView: CGRect] = [:]
    private var photoWidth:CGFloat!

    init(view: UIView) {
        self.view = view
      
    }

    func setupView() {
        behavior.apply(to: nextButton)
        photoWidth = (UIScreen.main.bounds.width - spacing * (CGFloat(numberOfColumns) + 1)) / CGFloat(numberOfColumns)
        
        // delete later
//        DataSet.shared.randomImagesForDataset(numOfPhotos: 100)
        approvedPhotos = Array(DataSet.shared.approvedPhotosData.values)
        // till here
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: TopBarManager.shared.topBar.bottomAnchor, constant: spacing),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        // Add instructions label
        let windowView = UIView(frame: CGRect(x: spacing, y: spacing, width: view.bounds.width - spacing*2, height: photoWidth))
        windowView.layer.cornerRadius = 16
        scrollView.addSubview(windowView)

        let instructionsLabel = UILabel(frame: CGRect(x: 0, y: windowView.frame.height/2 - 35, width: windowView.frame.width, height: 40))
        instructionsLabel.text = "Instructions"
        instructionsLabel.font = UIFont.boldSystemFont(ofSize: 24)
        instructionsLabel.textAlignment = .center
        windowView.addSubview(instructionsLabel)

        let additionalTextLabel = UILabel(frame: CGRect(x: 0, y: instructionsLabel.frame.maxY + 8, width: windowView.frame.width, height: 20))
        additionalTextLabel.text = "Please tap photos to increase significance lv."
        additionalTextLabel.font = UIFont.systemFont(ofSize: 16)
        additionalTextLabel.textAlignment = .center
        windowView.addSubview(additionalTextLabel)

        setupPhotoGrid()
    }

    func teardownView() {
        
        for subview in scrollView.subviews {
                subview.removeFromSuperview()
            }

            // Remove the scrollView from the main view
            scrollView.removeFromSuperview()

            // Clear the grid of image views
            grid.removeAll()

            // Clear all frames dictionary
            allFrames.removeAll()
    }

    func executeLogic() {
        Background.shared.changeZoom(newScale: 1.8, newX: 80, newY: 100, duration: 1){
            let effect = Effect2()
            Background.shared.setScrollInitials()
            Background.shared.addEffect(to: self.scrollView, effect: effect)
        }
      
    }

    deinit {
        print("\(self) is being deallocated")
    }
    
    
    private func setupPhotoGrid() {
        let screenWidth = view.bounds.width
        let numberOfRows = Int(ceil(Double(approvedPhotos.count) / Double(numberOfColumns)))

        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let index = row * numberOfColumns + column

                if index < approvedPhotos.count {
                    let photoData = approvedPhotos[index]
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: CGFloat(column) * (photoWidth + spacing) + spacing, y: CGFloat(row) * (photoWidth + spacing) + spacing*4+photoWidth, width: photoWidth, height: photoWidth)
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                  
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                    imageView.addGestureRecognizer(tapGestureRecognizer)
                    imageView.isUserInteractionEnabled = true

                    setImage(for: imageView, with: photoData.photoLocation)

                    scrollView.addSubview(imageView)
                    
                    // Fill the grid with the UIImageView pointers
                    let position = (row: row, column: column)
                    setImageView(imageView, at: position)

                    allFrames[imageView] = imageView.frame
                    
                    imageView.accessibilityIdentifier = photoData.photoLocation
                    imageView.tag = row * numberOfColumns + column
                }
            }
        }
        addNextButton()
        scrollView.contentSize = CGSize(width: screenWidth, height: CGFloat(numberOfRows)*(photoWidth+spacing)+spacing*4+photoWidth + spacing+buttonSize)
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            let position = (row: imageView.tag / numberOfColumns, column: imageView.tag % numberOfColumns)

            if let photoLocation = getPhotoIdentifier(at: position) {
                DataSet.shared.increaseSignificanceValue(for: photoLocation) { significanceLevel in
                    print("Significance level: \(significanceLevel)")
                    resizeImageView(imageView, significanceLevel: significanceLevel)
                }
            }
        }
    }


    func resizeImageView(_ imageView: UIImageView, significanceLevel: Int) {
        
        guard let initialFrame = allFrames[imageView] else { return }

        let newWidth = (photoWidth * CGFloat(significanceLevel)) + (CGFloat(significanceLevel) - 1) * spacing
        let newHeight = photoWidth * CGFloat(significanceLevel) + (CGFloat(significanceLevel) - 1) * spacing

        var newX = initialFrame.origin.x
        var newY = initialFrame.origin.y
        
        let currentPosition = position(from: imageView.tag)

        let canIncreaseRight = currentPosition.column + significanceLevel - 2 < 3
        let canIncreaseLeft = currentPosition.column > 0

        var direction: String?

        if canIncreaseRight && canIncreaseLeft {
            // Choose randomly to which size to increase
            let increaseToLeft = Bool.random()
            if increaseToLeft {
                newX = initialFrame.origin.x - photoWidth - spacing
                direction = "left"
            } else {
                direction = "right"
            }
        } else if !canIncreaseRight && canIncreaseLeft {
            // Increase to the left is the only legal option
            newX = initialFrame.origin.x - photoWidth - spacing
            direction = "left"
        } else {
            // If only increasing to the right is legal or both directions are illegal, keep the default newX
            direction = "right"
        }
        
        let newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)

        UIView.animate(withDuration: 0.3) {
            imageView.frame = newFrame
            // Modify the number label
            if let numberLabel = imageView.subviews.first(where: { $0.tag == 100 }) as? UILabel {
                numberLabel.text = "\(significanceLevel)"
                numberLabel.frame = CGRect(x: 5, y: imageView.bounds.height - 25, width: 30, height: 20)
            }
        }

        allFrames[imageView] = newFrame
        
        // only case where .tag can be chaned since if growin to the right - the place satays the same
        // moreover the row stays always the same.
        if direction == "left" {
            imageView.tag = imageView.tag - 1
        }
        if significanceLevel == 1 {
            let prevColumnRange = currentPosition.column..<(currentPosition.column + 4)
            let prevRowRange = currentPosition.row..<(currentPosition.row + 4)
            let currentPosition = position(from: imageView.tag)
            
            for row in prevRowRange {
                for column in prevColumnRange {
//                    let newPosition = (row: row, column: column)
                    if row != currentPosition.row || column != currentPosition.column {
                        // Delete empty slots
                        grid[row][column] = nil
                    }
                }
            }
        }

        if let direction = direction {
            updateGrid(imageView: imageView, direction: direction, resize: true)
        }
    }

    func updateGrid(imageView: UIImageView, direction: String, resize: Bool) {
        let currentPosition = position(from: imageView.tag)
        
        guard let photoLocation = imageView.accessibilityIdentifier,
              let photoData = DataSet.shared.approvedPhotosData[photoLocation]
        else { return }
        

        let significanceLevel = photoData.significanceValue
        
        let newColumnRange = currentPosition.column..<(currentPosition.column + significanceLevel)
        let newRowRange = currentPosition.row..<(currentPosition.row + significanceLevel)
        
//        var newRowRange = currentPosition.row..<(currentPosition.row + significanceLevel)
//        var newColumnRange = direction == "left" ? (currentPosition.column - 1)..<(currentPosition.column + significanceLevel - 1) : currentPosition.column..<(currentPosition.column + significanceLevel)
//        if direction == "down"{
//            newColumnRange = currentPosition.column..<(currentPosition.column + significanceLevel)
//            newRowRange = currentPosition.row..<(currentPosition.row + significanceLevel)
//        }
        
        // Custom struct for storing UIImageView references and conforming to Hashable
        struct ImageViewPair: Hashable {
            let colliding: UIImageView
            let collided: UIImageView
        }

        // Check for collisions
        var collisions = Set<ImageViewPair>()

        for row in newRowRange {
            for column in newColumnRange {
                let newPosition = (row: row, column: column)
                if let otherImageView = getImageView(at: newPosition), otherImageView != imageView {
                    let pair = ImageViewPair(colliding: imageView, collided: otherImageView)
                    collisions.insert(pair)
                }
                // Update the grid
                setImageView(imageView, at: (row: row, column: column))
            }
        }

        // Process collisions
        for collisioN in collisions {
            collision(colliding: collisioN.colliding, collided: collisioN.collided, direction: direction)
        }
        if resize {
            pullUp(location: currentPosition)
            shrinkGridIfNeeded()
        }
        
    }
    func pullUp(location: (row: Int, column: Int)){
        let newColumnRange = 0..<4
        let newRowRange = location.row..<grid.count
        
        for row in newRowRange {
            for column in newColumnRange {
                let pos = (row: row, column: column)
                if let imageView = getImageView(at: pos){
                    var realPosition = position(from: imageView.tag)
                    guard let photoLocation = imageView.accessibilityIdentifier,
                          let photoData = DataSet.shared.approvedPhotosData[photoLocation]
                    else { return }
                    
                    let significanceLevel = photoData.significanceValue
                    
                    var moovedBool = false
                    if canMoveUp(obj: imageView, otherObj: nil){
                        while (canMoveUp(obj: imageView, otherObj: nil)){
                            imageView.tag -= 4
                            for col in realPosition.column..<realPosition.column+significanceLevel{
                                setImageView(nil, at: (row: realPosition.row + significanceLevel - 1, column: col))
                            }
                            realPosition.row -= 1
                        }
                    }
                    if canMoveRight(obj: imageView){
                        var movedRight = 0
                        while canMoveRight(obj: imageView){
                            imageView.tag += 1
                            movedRight += 1
                            realPosition.column += 1

                            if canMoveUp(obj: imageView, otherObj: nil){
                                for col in (realPosition.column - movedRight)..<realPosition.column{
                                    for  row in realPosition.row..<realPosition.row + significanceLevel{
                                        setImageView(nil, at: (row: row, column: col))
                                    }
                                }
                                while (canMoveUp(obj: imageView, otherObj: nil)){
                                    imageView.tag -= 4
                                    for col in realPosition.column..<realPosition.column+significanceLevel{
                                        setImageView(nil, at: (row: realPosition.row + significanceLevel - 1, column: col))
                                    }
                                    realPosition.row -= 1
                                }
                                moovedBool = true
                                break
                            }
                        }
                        if !moovedBool{
                            imageView.tag -= movedRight
                            realPosition.column -= movedRight
                        }
                    }

                    if canMoveLeft(obj: imageView) && !moovedBool{
                        var movedLeft = 0
                        var moovedBool = false
                        while canMoveLeft(obj: imageView){
                            imageView.tag -= 1
                            movedLeft += 1
                            realPosition.column -= 1

                            if canMoveUp(obj: imageView, otherObj: nil){
                                for col in (realPosition.column + significanceLevel)..<(realPosition.column + significanceLevel+movedLeft){
                                    for  row in realPosition.row..<realPosition.row + significanceLevel{
                                        setImageView(nil, at: (row: row, column: col))
                                    }
                                }
                                while (canMoveUp(obj: imageView, otherObj: nil)){
                                    imageView.tag -= 4
                                    for col in realPosition.column..<realPosition.column+significanceLevel{
                                        setImageView(nil, at: (row: realPosition.row + significanceLevel - 1, column: col))
                                    }
                                    realPosition.row -= 1
                                }
                                moovedBool = true
                                break
                            }
                        }
                        if !moovedBool{
                            imageView.tag += movedLeft
                            realPosition.column += movedLeft
                        }
                    }
                    updateGrid(imageView: imageView, direction: "down", resize: false)
                    moveImageView(imageView, direction: "down", moveSteps: 4)
                }
            }
        }
    }

    func collision(colliding: UIImageView, collided: UIImageView, direction: String) {
        
        
        
        var collidedPosition = position(from: collided.tag)
        var collidingPosition = position(from: colliding.tag)

        
        guard let photoLocation = collided.accessibilityIdentifier,
              let photoData = DataSet.shared.approvedPhotosData[photoLocation]
        else { return }
        

        var significanceLevel = photoData.significanceValue
        
        
        guard let collidingLocation = colliding.accessibilityIdentifier,
              let collidingData = DataSet.shared.approvedPhotosData[collidingLocation]
        else { return }
        

        var collidingSignificanceLevel = collidingData.significanceValue
        
//        var collided = collided
//        var colliding = colliding
//
//        if collidingSignificanceLevel >= significanceLevel{
//            let temp = colliding
//            let tempPosition = collidingPosition
//            let tempSignificance = collidingSignificanceLevel
//
//            colliding = collided
//            collidingPosition = collidedPosition
//            collidingSignificanceLevel = significanceLevel
//
//            collided = temp
//            collidedPosition = tempPosition
//            significanceLevel = tempSignificance
//
//        }
        
        
        let range = 0..<significanceLevel
        
        var newPosition : (row: Int, column: Int)
//        var existingImageView  = getImageView(at: collidedPosition)
        var newDirection : String
        var moveSteps : Int = 0
        
        if direction == "right" && collidedPosition.column + significanceLevel - 1 < 3 &&
            collidedPosition.row != collidingPosition.row + collidingSignificanceLevel - 1{
            newPosition = (row: collidedPosition.row, column: collidedPosition.column + 1)
//            existingImageView = getImageView(at: newPosition)
            newDirection = direction
            collided.tag += 1
            moveSteps += 1
            while areColliding(obj: collided, otherObj: colliding) {
                moveSteps += 1
                collided.tag -= 1
                newPosition.column += 1
//                existingImageView = getImageView(at: newPosition)
                var prevPosition = position(from: collided.tag - 1)
                for _ in range{
                    if getImageView(at: prevPosition) == collided {
                        grid[prevPosition.row][prevPosition.column] = nil
                    }
                    prevPosition.row += 1
                }
                while canMoveUp(obj: collided, otherObj: nil){
                    collided.tag -= 4
                }
                while canMoveUp(obj: collided, otherObj: colliding){
                    collided.tag -= 4
                }
            }
        }
        
        else if direction == "left" && collidedPosition.column > 0 &&
                    collidedPosition.row != collidingPosition.row + collidingSignificanceLevel - 1{
            newPosition = (row: collidedPosition.row, column: collidedPosition.column - 1)
//            existingImageView = getImageView(at: newPosition)
            newDirection = direction
            collided.tag -= 1
            moveSteps += 1
            while areColliding(obj: collided, otherObj: colliding) {
                moveSteps += 1
                collided.tag -= 1
                newPosition.column -= 1
//                existingImageView = getImageView(at: newPosition)
                var prevPosition = position(from: collided.tag + 1)
                for _ in range{
                    if getImageView(at: prevPosition) == collided {
                        grid[prevPosition.row][prevPosition.column + significanceLevel - 1] = nil
                    }
                    prevPosition.row += 1
                }
            }
            while canMoveUp(obj: collided, otherObj: nil){
                collided.tag -= 4
            }
            while canMoveUp(obj: collided, otherObj: colliding){
                collided.tag -= 4
            }
        }
        
        else {
            newPosition = (row: collidedPosition.row + 1, column: collidedPosition.column)
            collided.tag += 4
//            existingImageView = getImageView(at: newPosition)
            moveSteps += 1
            var prevPosition = position(from: collided.tag - 4)
            for _ in range{
                if getImageView(at: prevPosition) == collided {
                    grid[prevPosition.row][prevPosition.column] = nil
                }
                prevPosition.column += 1
            }
            
            while areColliding(obj: collided, otherObj: colliding) {
                moveSteps += 1
                collided.tag += 4
                newPosition.row += 1
//                existingImageView = getImageView(at: newPosition)
                var prevPosition = position(from: collided.tag - 4)
                for _ in range{
                    if getImageView(at: prevPosition) == collided {
                        grid[prevPosition.row][prevPosition.column] = nil
                    }
                    prevPosition.column += 1
                }
            }
            newDirection = "down"
        }

        moveImageView(collided, direction: newDirection, moveSteps: moveSteps)
        updateGrid(imageView: collided, direction: newDirection, resize: false)
    }
    

    func moveImageView(_ imageView: UIImageView, direction: String, moveSteps: Int) {
        guard let initialFrame = allFrames[imageView] else { return }
        
        var newX = initialFrame.origin.x
        var newY = initialFrame.origin.y
        
        switch direction {
        case "left":
            newX -= (photoWidth + spacing) * CGFloat(moveSteps)
        case "right":
            newX += (photoWidth + spacing) * CGFloat(moveSteps)
        case "down":
            newY += (photoWidth + spacing) * CGFloat(moveSteps)
        default:
            break
        }
        
//        let newFrame = CGRect(x: newX, y: newY, width: initialFrame.width, height: initialFrame.height)
//
//        UIView.animate(withDuration: 0.3) {
//            imageView.frame = newFrame
//        }
        guard let photoLocation = imageView.accessibilityIdentifier,
              let photoData = DataSet.shared.approvedPhotosData[photoLocation]
        else { return }
        

        let significanceLevel = photoData.significanceValue
        
        let curPhotoWidth = photoWidth*CGFloat(significanceLevel) + spacing*CGFloat(significanceLevel - 1)
        
        let newPosition = position(from: imageView.tag)
        let newFrame = CGRect(x: CGFloat(newPosition.column) * (photoWidth + spacing) + spacing, y: CGFloat(newPosition.row) * (photoWidth + spacing) + spacing*4+photoWidth, width: curPhotoWidth, height: curPhotoWidth)
        
        UIView.animate(withDuration: 0.3) {
            imageView.frame = newFrame
        }
        
        

        allFrames[imageView] = newFrame
    }

    func updateGridForMovedImageView(_ imageView: UIImageView, newPosition: (row: Int, column: Int)) {
        setImageView(imageView, at: newPosition)
        imageView.tag = newPosition.row * numberOfColumns + newPosition.column
    }


    private func setImage(for imageView: UIImageView, with localIdentifier: String) {
        imageView.image = DataSet.shared.approvedPhotosData[localIdentifier]?.image
        
        // Add number label
        let numberLabel = UILabel(frame: CGRect(x: 5, y: imageView.bounds.height - 25, width: 30, height: 20))
        numberLabel.text = "1"
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = .black
        numberLabel.textColor = .white
        numberLabel.layer.cornerRadius = 10
        numberLabel.clipsToBounds = true
        numberLabel.tag = 100 // Assign a unique tag to the label
        imageView.addSubview(numberLabel)
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "localIdentifier = %@", localIdentifier)
//        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
//
//        if let asset = fetchResult.firstObject {
//            let manager = PHImageManager.default()
//            let requestOptions = PHImageRequestOptions()
//            requestOptions.isSynchronous = true
//            requestOptions.isNetworkAccessAllowed = true
//            manager.requestImage(for: asset, targetSize: CGSize(width: 300, height: x0), contentMode: .aspectFill, options: requestOptions) { (image, _) in
//                if let image = image {
//                    imageView.image = image
//
//
//                    // Add number label
//                    let numberLabel = UILabel(frame: CGRect(x: 5, y: imageView.bounds.height - 25, width: 30, height: 20))
//                    numberLabel.text = "1"
//                    numberLabel.textAlignment = .center
//                    numberLabel.backgroundColor = .black
//                    numberLabel.textColor = .white
//                    numberLabel.layer.cornerRadius = 10
//                    numberLabel.clipsToBounds = true
//                    numberLabel.tag = 100 // Assign a unique tag to the label
//                    imageView.addSubview(numberLabel)
//                }
//            }
//        }
    }

    
    
    func areColliding(obj: UIImageView!, otherObj: UIImageView!) -> Bool{
        
        if obj == nil{return false}
        
        let objPosition = position(from: obj.tag)
        
        guard let objLocation = obj.accessibilityIdentifier,
              let objData = DataSet.shared.approvedPhotosData[objLocation]
        else {return false}
        
        
        let significance_Colliding = objData.significanceValue
        
        let newColumnRange = objPosition.column..<(objPosition.column + significance_Colliding)
        let newRowRange = objPosition.row..<(objPosition.row + significance_Colliding)
        
        for row in newRowRange {
            for column in newColumnRange {
                let newPosition = (row: row, column: column)
                if let otherImageView = getImageView(at: newPosition), otherImageView == otherObj {
                    return true
                }
            }
        }
        return false
    }
    
    func canMoveUp(obj: UIImageView!, otherObj: UIImageView!) -> Bool{
        
        let objPosition = position(from: obj.tag)
        
        if objPosition.row  < 1 {return false}
        
        let onSamePlace = getImageView(at: objPosition)
        
        guard let objLocation = obj.accessibilityIdentifier,
              let objData = DataSet.shared.approvedPhotosData[objLocation]
        else {return false}
        
        let significance_Colliding = objData.significanceValue
        
        let newColumnRange = objPosition.column..<(objPosition.column + significance_Colliding)
        let row = objPosition.row - 1
        
        
        for column in newColumnRange {
            let newPosition = (row: row, column: column)
            if let otherImageView = getImageView(at: newPosition){
                if otherImageView != onSamePlace{
                    return false
                }
            }
        }
        return true
    }
    
    func canMoveRight(obj: UIImageView!) -> Bool{
        
        let objPosition = position(from: obj.tag)
            
        guard let objLocation = obj.accessibilityIdentifier,
              let objData = DataSet.shared.approvedPhotosData[objLocation]
        else {return false}
        
        let significance_Colliding = objData.significanceValue
        
        if objPosition.column+significance_Colliding  > 3 {return false}
        
        let newRowRange = objPosition.row..<(objPosition.row + significance_Colliding)
        let column = objPosition.column+significance_Colliding
        
        for row in newRowRange {
            let newPosition = (row: row, column: column)
            if let otherImageView = getImageView(at: newPosition){
                return false
            }
        }
        return true
    }
    
    func canMoveLeft(obj: UIImageView!) -> Bool{
        
        let objPosition = position(from: obj.tag)
            
        guard let objLocation = obj.accessibilityIdentifier,
              let objData = DataSet.shared.approvedPhotosData[objLocation]
        else {return false}
        
        let significance_Colliding = objData.significanceValue
        
        if objPosition.column < 1 {return false}
        
        let newRowRange = objPosition.row..<(objPosition.row + significance_Colliding)
        let column = objPosition.column - 1
        
        for row in newRowRange {
            let newPosition = (row: row, column: column)
            if let otherImageView = getImageView(at: newPosition){
                return false
            }
        }
        return true
    }
        
    
    
    
    private func expandGridIfNeeded(row: Int, column: Int) {
        while row >= grid.count {
            grid.append(Array(repeating: nil, count: numberOfColumns))
        }
        scrollView.contentSize = CGSize(width:  view.bounds.width, height: CGFloat(grid.count) * (photoWidth+spacing) + spacing*4+photoWidth + spacing+buttonSize)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.nextButton.frame = CGRect(x: self.spacing, y: CGFloat(self.grid.count) * (self.photoWidth+self.spacing) + self.spacing*4+self.photoWidth, width: self.view.bounds.width - self.spacing*2, height: self.buttonSize)
//
//        })
        let newButtonX = self.spacing
        let newButtonY = CGFloat(self.grid.count) * (self.photoWidth + self.spacing) + self.spacing * 4 + self.photoWidth
        let newButtonWidth = self.view.bounds.width - self.spacing * 2
        let newButtonHeight = self.buttonSize

        let newFrame = CGRect(x: newButtonX, y: newButtonY, width: newButtonWidth, height: newButtonHeight)

        UIView.animate(withDuration: 0.3) {
            self.nextButton.frame = newFrame
        }

    }
    
    
    private func shrinkGridIfNeeded() {
        var endIndex = grid.endIndex - 1
        while endIndex >= 0 {
            let row = grid[endIndex]
            let isAllNil = row.allSatisfy { $0 == nil }
            
            if isAllNil {
                grid.remove(at: endIndex)
                let newContentSize = CGSize(width:  view.bounds.width, height: CGFloat(grid.count) * (photoWidth+spacing) + spacing*4+photoWidth + spacing+buttonSize)
                
                scrollView.showsVerticalScrollIndicator = false

                // Animate the change in content size
                UIView.animate(withDuration: 0.3, animations: {
                    // Update the content size of the scroll view
                    self.scrollView.contentSize = newContentSize
                    self.nextButton.frame = CGRect(x: self.spacing, y: CGFloat(self.grid.count) * (self.photoWidth+self.spacing) + self.spacing*4+self.photoWidth, width: self.view.bounds.width - self.spacing*2, height: self.buttonSize)

//                    // If needed, adjust the position of the scroll view's content to ensure visibility
//                    self.scrollView.contentOffset = CGPoint(x: 0, y: max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height))
                }) { (_) in
                    // Re-enable the scroll indicator after the animation completes
                    self.scrollView.showsVerticalScrollIndicator = true
                }
            } else {
                break
            }
            
            endIndex -= 1
        }
    }
    
//    private func shrinkGridIfNeeded() {
//        var endIndex = grid.endIndex - 1
//        while endIndex >= 0 {
//            let row = grid[endIndex]
//            let isAllNil = row.allSatisfy { $0 == nil }
//            var emptyRows = 0
//
//            if isAllNil {
//                grid.remove(at: endIndex)
//                emptyRows += 1
//            } else {
//                if emptyRows > 0 {
//                    UIView.animate(withDuration: 0.3) {
//                        self.scrollView.contentSize = CGSize(width:  self.view.bounds.width, height: CGFloat(self.grid.count) * (self.photoWidth+self.spacing))
//                    }
//                }
//                break
//            }
//
//            endIndex -= 1
//        }
//    }

    

    func getPhotoIdentifier(at position: (row: Int, column: Int)) -> String? {
        expandGridIfNeeded(row: position.row, column: position.column)
        return grid[position.row][position.column]?.accessibilityIdentifier
    }
    
    func getImageView(at position: (row: Int, column: Int)) -> UIImageView? {
        expandGridIfNeeded(row: position.row, column: position.column)

        return grid[position.row][position.column]
    }

    func setImageView(_ imageView: UIImageView?, at position: (row: Int, column: Int)) {
        expandGridIfNeeded(row: position.row, column: position.column)
        grid[position.row][position.column] = imageView
    }
    
    func position(from tag: Int) -> (row: Int, column: Int) {
        let row = tag / numberOfColumns
        let column = tag % numberOfColumns
        return (row: row, column: column)
    }
    
    func addNextButton(){
        // Add a button to the view
        nextButton.setTitle("Done", for: .normal)
        nextButton.backgroundColor = .black
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.frame = CGRect(x: spacing, y: CGFloat(grid.count) * (photoWidth+spacing) + spacing*4+photoWidth, width: view.bounds.width - spacing*2, height: buttonSize)
        scrollView.addSubview(nextButton)

//        // Constrain the button in the view
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//        nextButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor), // Position the button below the scrollView
//        nextButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//        nextButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//        nextButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor), // Place the button at the bottom of the scrollView
//        nextButton.heightAnchor.constraint(equalToConstant: 50) // Set the desired height of the button
//        ])
    }
    
    @objc func nextButtonTapped() {
        self.delegate?.handler(self, didFinishWithTransitionTo: ExplainCompareVC.self)
    }
}

