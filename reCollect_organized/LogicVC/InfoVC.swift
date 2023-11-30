
//
//  TestInfoVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 13/07/2023.
//


import UIKit
import SwiftUI


class InfoVC: NSObject, ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    let genderOptions = ["Male", "Female", "Other"]
    let  countries: [String] = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    
    let view: UIView
    var captionLabel: UILabel
    
    
    var fullNameField: UITextField!
    var birthDateField: CustomInfoPlaceholder!
    var genderField: CustomInfoPlaceholder!
    var countryField: CustomInfoPlaceholder!
    
    // Define constants for layout
    var captionTopConstant: CGFloat 
    var fullNameTopConstant: CGFloat
    var birthDateTopConstant: CGFloat
    var genderTopConstant: CGFloat
    var countryTopConstant: CGFloat
    var nextConstant: CGFloat
    var FieldsPadding : CGFloat
    var allFieldsFilled: Bool = false
    var nextButton: CustomNextButton!

    
    var imojiHostingController: UIHostingController<SelfImoji>!
    var viewModel: ImojiViewModel
    
    
    init(view: UIView) {
        self.view = view
        self.FieldsPadding = 10 * view.frame.height / 844
        self.captionTopConstant = 280 * view.frame.height / 844
        self.fullNameTopConstant = 351 * view.frame.height / 844
        self.birthDateTopConstant = self.fullNameTopConstant + 53 + self.FieldsPadding
        self.genderTopConstant = self.birthDateTopConstant + 53 + self.FieldsPadding
        self.countryTopConstant = self.genderTopConstant + 53 + self.FieldsPadding
        self.nextConstant = self.countryTopConstant + 53 + (self.FieldsPadding) * 3 
        
        self.captionLabel = UILabel()
        self.captionLabel = UILabel()
        self.nextButton = CustomNextButton(behavior: ScaleBehavior())


        // Create the hosting controller with the SwiftUI view in UIKit class
        viewModel = ImojiViewModel()
        imojiHostingController = UIHostingController(rootView: SelfImoji(viewModel: viewModel))
        
        super.init()
        
//        self.fullNameField.delegate = self
        self.fullNameField = makeFullNameField()
        self.birthDateField = makeBirthDateField()
        self.genderField = makeGenderField()
        self.countryField = makeCountryField()
        
        
        captionLabel.text = "Personal Details"
        captionLabel.font = UIFont.boldSystemFont(ofSize: 24)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.imojiHostingController.view.alpha = 0
        self.captionLabel.alpha = 0
        self.fullNameField.alpha = 0
        self.birthDateField.alpha = 0
        self.genderField.alpha = 0
        self.countryField.alpha = 0
    }
    
    func setupView() {
        // Add objects to view hierarchy
        view.addSubview(imojiHostingController.view)
        view.addSubview(captionLabel)
        view.addSubview(fullNameField)
        view.addSubview(birthDateField)
        view.addSubview(genderField)
        view.addSubview(countryField)
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        
        // Position and constrain the label and fields
        setupImoji()
        setupLabelOrField(captionLabel, topAnchorConstant: captionTopConstant )
        setupLabelOrField(fullNameField, topAnchorConstant: fullNameTopConstant)
        setupLabelOrField(birthDateField, topAnchorConstant: birthDateTopConstant)
        setupLabelOrField(genderField, topAnchorConstant: genderTopConstant)
        setupLabelOrField(countryField, topAnchorConstant: countryTopConstant)
        setupLabelOrField(nextButton, topAnchorConstant: nextConstant)
        
        
        // Add tap gesture recognizer to view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    func setupImoji(){
        imojiHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        imojiHostingController.view.backgroundColor = UIColor.clear
        imojiHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imojiHostingController.view.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }
    
    func setupLabelOrField(_ object: UIView, topAnchorConstant: CGFloat) {
        object.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        object.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topAnchorConstant).isActive = true
    }
    
    func teardownView() {
        // Remove the caption label and fields from the view hierarchy
        imojiHostingController.view.removeFromSuperview()
        captionLabel.removeFromSuperview()
        fullNameField.removeFromSuperview()
        birthDateField.removeFromSuperview()
        genderField.removeFromSuperview()
        countryField.removeFromSuperview()
        nextButton.removeFromSuperview()
    }
    
    func executeLogic() {
        
        Background.shared.changeZoom(newScale: 2.5, newX: 70, newY: -30, duration: 1)
        
        // Animate the caption label
        UIView.animate(withDuration: 1.0) {
            self.imojiHostingController.view.alpha = 1
            self.captionLabel.alpha = 1
            self.fullNameField.alpha = 0.9
            self.birthDateField.alpha = 0.9
            self.genderField.alpha = 0.9
            self.countryField.alpha = 0.9
        }
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        FirebaseManager.shared.saveUserData(name: fullNameField.text!, age: birthDateField.text!, gender: genderField.text!, country: countryField.text!)
        // Animate the caption label
        UIView.animate(withDuration: 1, animations: {
            self.imojiHostingController.view.alpha = 0
            self.captionLabel.alpha = 0
            self.fullNameField.alpha = 0
            self.birthDateField.alpha = 0
            self.genderField.alpha = 0
            self.countryField.alpha = 0
            self.nextButton.alpha = 0
        }){ _ in
            self.delegate?.handler(self, didFinishWithTransitionTo: ExplainChooseVC.self)
        }
    }
    
}


//import UIKit
//
//class TestInfoVC: ViewControllerHandler {
//    weak var delegate: ViewControllerHandlerDelegate?
//    let view: UIView
//    let captionLabel: UILabel
//
//    init(view: UIView) {
//        self.view = view
//        self.captionLabel = UILabel()
//        captionLabel.text = "Personal Details"
//        captionLabel.alpha = 0
//        captionLabel.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    func setupView() {
//        // Add the caption label to the view hierarchy
//        view.addSubview(captionLabel)
//
//        // Position and constrain the label
//        captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        captionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height / 4).isActive = true
//
//        // Add the top bar to the view hierarchy
//        TopBarManager.shared.addToView(view)
//    }
//
//    func teardownView() {
//        // Remove the caption label from the view hierarchy
//        captionLabel.removeFromSuperview()
//
//        // TODO: remove the top bar from the view hierarchy, if necessary
//    }
//
//    func executeLogic() {
//        // Animate the top bar height
//        TopBarManager.shared.animateHeight(to: 88)
//
//        // Animate the caption label
//        UIView.animate(withDuration: 1.0) {
//            self.captionLabel.alpha = 1.0
//        }
//    }
//}


//import UIKit
//
//class TestInfoVC: ViewControllerHandler {
//    weak var delegate: ViewControllerHandlerDelegate?
//    let view: UIView
//    let captionLabel: UILabel
//    let fullNameField: CustomInfoPlaceholder
//    let birthDateField: CustomInfoPlaceholder
//    let genderField: CustomInfoPlaceholder
//    let countryField: CustomInfoPlaceholder
//
//    init(view: UIView) {
//        self.view = view
//        self.captionLabel = UILabel()
//        captionLabel.text = "Personal Details"
//        captionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        captionLabel.alpha = 0
//        captionLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.fullNameField = CustomInfoPlaceholder(placeholder: "Full Name")
//        self.birthDateField = CustomInfoPlaceholder(placeholder: "Date of Birth")
//        self.genderField = CustomInfoPlaceholder(placeholder: "Gender")
//        self.countryField = CustomInfoPlaceholder(placeholder: "Country")
//    }
//
//    func setupView() {
//        // Add the caption label to the view hierarchy
//        view.addSubview(captionLabel)
//        view.addSubview(fullNameField)
//        view.addSubview(birthDateField)
//        view.addSubview(genderField)
//        view.addSubview(countryField)
//
//        // Position and constrain the label and fields
//        captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        captionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 258/844).isActive = true
//        setupField(fullNameField, below: captionLabel, padding: view.frame.height * (361-258)/844)
//        setupField(birthDateField, below: fullNameField, padding: 10)
//        setupField(genderField, below: birthDateField, padding: 10)
//        setupField(countryField, below: genderField, padding: 10)
//
//        // Add the top bar to the view hierarchy
//        TopBarManager.shared.addToView(view)
//    }
//
//    func setupField(_ field: UITextField, below view: UIView, padding: CGFloat) {
//        field.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        field.topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding).isActive = true
//        field.widthAnchor.constraint(equalToConstant: field.intrinsicContentSize.width).isActive = true
//        field.heightAnchor.constraint(equalToConstant: field.intrinsicContentSize.height).isActive = true
//    }
//
//    func teardownView() {
//        // Remove the caption label and fields from the view hierarchy
//        captionLabel.removeFromSuperview()
//        fullNameField.removeFromSuperview()
//        birthDateField.removeFromSuperview()
//        genderField.removeFromSuperview()
//        countryField.removeFromSuperview()
//        }
//
//    func executeLogic() {
//        // Animate the top bar height
//        TopBarManager.shared.animateHeight(to: 88)
//
//        // Animate the caption label
//        UIView.animate(withDuration: 1.0) {
//            self.captionLabel.alpha = 1.0
//        }
//    }
//}
//

//// Working new one ///
//
//
//import UIKit
//
//
//class TestInfoVC: NSObject, ViewControllerHandler {
//    weak var delegate: ViewControllerHandlerDelegate?
//    let view: UIView
//    var fullNameField: UITextField!
//    let captionLabel: UILabel
//    let birthDateField: CustomInfoPlaceholder
//    let genderField: CustomInfoPlaceholder
//    let countryField: CustomInfoPlaceholder
//
//    // Define constants for layout
//    var captionTopConstant: CGFloat
//    var fullNameTopConstant: CGFloat
//    var birthDateTopConstant: CGFloat
//    var genderTopConstant: CGFloat
//    var countryTopConstant: CGFloat
//
//    init(view: UIView) {
//        self.view = view
//        self.captionTopConstant = view.frame.height * 258/844
//        self.fullNameTopConstant = view.frame.height * 361/844
//        self.birthDateTopConstant = self.fullNameTopConstant + 53 + 10
//        self.genderTopConstant = self.birthDateTopConstant + 53 + 10
//        self.countryTopConstant = self.genderTopConstant + 53 + 10
//
//        self.captionLabel = UILabel()
//        self.birthDateField = CustomInfoPlaceholder(placeholder: "Date of Birth")
//        self.genderField = CustomInfoPlaceholder(placeholder: "Gender")
//        self.countryField = CustomInfoPlaceholder(placeholder: "Country")
//
//        super.init()
//
//        self.fullNameField = makeFullNameField()
//        self.fullNameField.delegate = self
//
//        captionLabel.text = "Personal Details"
//        captionLabel.font = UIFont.boldSystemFont(ofSize: 24)
//        captionLabel.alpha = 0
//        captionLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        self.fullNameField.alpha = 0
//        self.birthDateField.alpha = 0
//        self.genderField.alpha = 0
//        self.countryField.alpha = 0
//    }
//
//    func setupView() {
//        // Add the caption label to the view hierarchy
//        view.addSubview(captionLabel)
//        view.addSubview(fullNameField)
//        view.addSubview(birthDateField)
//        view.addSubview(genderField)
//        view.addSubview(countryField)
//
//        // Position and constrain the label and fields
//        setupLabelOrField(captionLabel, topAnchorConstant: captionTopConstant)
//        setupLabelOrField(fullNameField, topAnchorConstant: fullNameTopConstant)
//        setupLabelOrField(birthDateField, topAnchorConstant: birthDateTopConstant)
//        setupLabelOrField(genderField, topAnchorConstant: genderTopConstant)
//        setupLabelOrField(countryField, topAnchorConstant: countryTopConstant)
//
//        // Add the top bar to the view hierarchy
//        TopBarManager.shared.addToView(view)
//    }
//
//    func setupLabelOrField(_ object: UIView, topAnchorConstant: CGFloat) {
//        object.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        object.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topAnchorConstant).isActive = true
//    }
//
//    func teardownView() {
//        // Remove the caption label and fields from the view hierarchy
//        captionLabel.removeFromSuperview()
//        fullNameField.removeFromSuperview()
//        birthDateField.removeFromSuperview()
//        genderField.removeFromSuperview()
//        countryField.removeFromSuperview()
//
//        // TODO: remove the top bar from the view hierarchy, if necessary
//    }
//
//    func executeLogic() {
//
//        Background.shared.changeZoom(newScale: 2.5, newX: 70, newY: -30, duration: 1)
//
//        // Animate the top bar height
//        TopBarManager.shared.extendBar()
//
//        // Animate the caption label
//        UIView.animate(withDuration: 1.0) {
//            self.captionLabel.alpha = 1
//            self.fullNameField.alpha = 0.9
//            self.birthDateField.alpha = 0.9
//            self.genderField.alpha = 0.9
//            self.countryField.alpha = 0.9
//        }
//    }
//}


// try to add swiftUI ///
