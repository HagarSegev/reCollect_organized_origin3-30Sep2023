//
//  InfoPlacholdersExtensions.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 13/07/2023.
//

import UIKit

extension InfoVC: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fullNameField {
            print("Full name is: \(textField.text ?? "")")
            viewModel.fadeInEyes()
        }
        else if textField == birthDateField {
            print("Birth date is: \(textField.text ?? "")")
            viewModel.fadeInMouth()
        }
        else if textField == genderField {
            print("Gender is: \(textField.text ?? "")")
            viewModel.revealEars()
        }
        else if textField == countryField {
            print("Country is: \(textField.text ?? "")")
            viewModel.thumbsUp()
        }
        
        // Check if all fields are filled
        checkIfAllFieldsFilled()
    }
    
    func checkIfAllFieldsFilled() {
        if fullNameField.text != "" && birthDateField.text != "" && genderField.text != "" && countryField.text != "" {
            allFieldsFilled = true
        }
        else {
            allFieldsFilled = false
        }
        
        nextButton.animateButton(shouldShow: allFieldsFilled)
    }
    
    @objc func doneButtonAction() {
        if fullNameField.isFirstResponder && fullNameField.text != "" {
            if birthDateField.text == "" {
                birthDateField.becomeFirstResponder()
            }
            else {view.endEditing(true)}
        }
        else if birthDateField.isFirstResponder && birthDateField.text != "" {
            if genderField.text == "" {
                genderField.becomeFirstResponder()
            }
            else {view.endEditing(true)}
            
        }
        else if genderField.isFirstResponder && genderField.text != "" {
            if countryField.text == "" {
                countryField.becomeFirstResponder()
            }
            else {view.endEditing(true)}
        }
        else if countryField.isFirstResponder && countryField.text != "" {
            view.endEditing(true)
        }
        
//        // Check if all fields are filled
//        if fullNameField.text != "" && birthDateField.text != "" && genderField.text != "" && countryField.text != "" {
//            allFieldsFilled = true
//        }
//        else {
//            allFieldsFilled = false
//        }
//
//        nextButton.animateButton(shouldShow: allFieldsFilled)

    }

    
    @objc func handleTap() {
        view.endEditing(true)
        
//        // Full Name
//        if let text = fullNameField.text, !text.isEmpty {
//            print("Full name is: \(text)")
//            viewModel.fadeInEyes()
//        }
//        
//        // Birth Date
//        if let text = birthDateField.text, !text.isEmpty {
//            print("Birth date is: \(text)")
//            viewModel.fadeInMouth() // Assuming fadeInMouth for birth date field
//        }
//        
//        // Gender
//        if let text = genderField.text, !text.isEmpty {
//            print("Gender is: \(text)")
//            viewModel.revealEars() // Assuming revealEars for gender field
//        }
//        
//        // Country
//        if let text = countryField.text, !text.isEmpty {
//            print("Country is: \(text)")
//            viewModel.thumbsUp() // Assuming thumbsUp for country field
//        }
//        
//        // Check if all fields are filled
//        if fullNameField.text != "" && birthDateField.text != "" && genderField.text != "" && countryField.text != "" {
//            allFieldsFilled = true
//        }
//        else {
//            allFieldsFilled = false
//        }
//        
//        nextButton.animateButton(shouldShow: allFieldsFilled)

    }

    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // Picker scroll configurations
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Number of columns of data
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderField.inputView {
            return genderOptions.count
        } else if pickerView == countryField.inputView {
            return countries.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderField.inputView {
            return genderOptions[row]
        } else if pickerView == countryField.inputView {
            return countries[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderField.inputView {
            genderField.text = genderOptions[row]
        } else if pickerView == countryField.inputView {
            countryField.text = countries[row]
        }
    }
    
    // Don't dismiss the keyboard
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        birthDateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    // Make fields:
    
    func makeFullNameField() -> CustomInfoPlaceholder {
        let field = CustomInfoPlaceholder(placeholder: "Full Name")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.borderStyle = .none
        
        // Create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // Create a flexible space item so that you can add done button on right side
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        // Create a "Done" button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction))
        
        // Add the buttons to the toolbar
        toolbar.items = [flexButton, doneButton]
        
        // Set the toolbar as the input accessory view of the text field
        field.inputAccessoryView = toolbar
        
        return field
    }
    
    func makeBirthDateField() -> CustomInfoPlaceholder {
        let field = CustomInfoPlaceholder(placeholder: "Date of Birth")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.borderStyle = .none

        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)

        // Set the initial date to 04 February 1979
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:yyyy"
        if let initialDate = dateFormatter.date(from: "04:02:1979") {
            datePicker.date = initialDate
        }

        field.inputView = datePicker

        // Create a toolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction))
        toolbar.items = [flexButton, doneButton]
        field.inputAccessoryView = toolbar

        return field
    }

    
    func makeGenderField() -> CustomInfoPlaceholder {
        let field = CustomInfoPlaceholder(placeholder: "Gender")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        
        field.borderStyle = .none
        
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        field.inputView = genderPicker
        
        // Create a toolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction))
        toolbar.items = [flexButton, doneButton]
        field.inputAccessoryView = toolbar
        
        return field
    }
    
    
    func makeCountryField() -> CustomInfoPlaceholder {
        let field = CustomInfoPlaceholder(placeholder: "Country")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self

        // Remove the border
        field.borderStyle = .none
        
        let countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        field.inputView = countryPicker
        
        // Create a toolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneButtonAction))
        toolbar.items = [flexButton, doneButton]
        field.inputAccessoryView = toolbar
        
        return field
    }
}

