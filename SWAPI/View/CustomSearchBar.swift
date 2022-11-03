//
//  CustomSearchBar.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import UIKit

protocol CustomSearchBarDelegate: class {
//    func textFieldDidBeginEditing()
//    func textFieldDidEndEditing()
    func textDidChange(searchBar: CustomSearchBar, text: String)
    
    func cancelButtonPressed(on searchBar: CustomSearchBar)
}

class CustomSearchBar: UIView, UITextFieldDelegate {
   
    weak var delegate: CustomSearchBarDelegate?
    let textField = UITextField()
    let cancelBtn = UIButton(type: .system)
    fileprivate var widthConstraint: NSLayoutConstraint?
    var isSearching: Bool = false {
        didSet {
            if isSearching {
                UIView.animate(withDuration: 0.2, animations: {
                    self.widthConstraint?.constant += -(self.cancelBtn.frame.width)-8
                    self.layoutIfNeeded()
                }) { (bool) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.cancelBtn.alpha = 1
                        self.layoutIfNeeded()
                    })
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.cancelBtn.alpha = 0
                    self.layoutIfNeeded()
                }) { (bool) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.widthConstraint?.constant = -8
                        self.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public convenience init(){
        self.init(frame: .zero)
        setupView()
    }
    
    private func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.swapiTitleBackground
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = UIColor.swapiBackground
        textField.textColor = UIColor.swapiYellow
        textField.tintColor = UIColor.swapiYellow
        textField.attributedPlaceholder = NSAttributedString(string: "Search..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.swapiYellow])
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        widthConstraint = textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        widthConstraint?.isActive = true
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        if let clearButton = textField.value(forKey: "_clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .swapiYellow
        }
        
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.tintColor = UIColor.swapiYellow
        cancelBtn.alpha = 0
        addSubview(cancelBtn)
        cancelBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        cancelBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
//        delegate?.textFieldDidBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearching = false
//        delegate?.textFieldDidEndEditing()
    }
    
    
    @objc func textFieldDidChange(){
        if let text = textField.text {
            delegate?.textDidChange(searchBar: self, text: text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            delegate?.textDidChange(searchBar: self, text: text)
        }
        textField.resignFirstResponder()
        return false
    }
    
    @objc func cancelButtonPressed() {
        textField.text = ""
        textField.endEditing(true)
        delegate?.cancelButtonPressed(on: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let correctInput = NSCharacterSet(charactersIn:" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-+")
        let characterSetFromTextField = NSCharacterSet(charactersIn: string)
        return correctInput.isSuperset(of: characterSetFromTextField as CharacterSet) 
    }
}
