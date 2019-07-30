//
//  TodoTableViewCell.swift
//  Daimo
//
//  Created by sogih on 14/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    
    // MARK:- Views
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.veryLightPink
        view.layer.cornerRadius = 8
        return view
    }()
    
    
    let checkBoxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        let unCheckBox = UIImage(named: "UnCheckBox")?.withRenderingMode(.alwaysTemplate)
        let checkBox = UIImage(named: "CheckBox")?.withRenderingMode(.alwaysTemplate)
        button.setImage(unCheckBox, for: .normal)
        button.setImage(checkBox, for: .selected)
        return button
    }()
    
    let todoTextField: UITextField = {
        let textField = UITextField ()
        textField.clearButtonMode = .never
        textField.autocapitalizationType = .none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.spellCheckingType = UITextSpellCheckingType.no
        textField.enablesReturnKeyAutomatically = true
        textField.isUserInteractionEnabled = true
        textField.returnKeyType = .done
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.font = UIFont.todo
//        textField.keyboardAppearance = .dark
        return textField
    }()
    
    lazy var accessory: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.veryLightPink
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 38)
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red:0.54, green:0.54, blue:0.54, alpha:1.0)
        button.layer.cornerRadius = 4
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    
    override func prepareForReuse() {
        todoTextField.text =  nil
        todoTextField.isUserInteractionEnabled = true
    }
    
    // MARK:- Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- SaetupUI
extension TodoTableViewCell {
    func setupUI() {
        self.backgroundColor = .white
        
        
        contentView.addSubview(bgView)
        bgView.addSubview(checkBoxButton)
        bgView.addSubview(todoTextField)
        todoTextField.inputAccessoryView = accessory
        accessory.addSubview(cancelButton)
        
        bgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-3)
        }
        checkBoxButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(22)
        }
        todoTextField.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp_trailingMargin).offset(12)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().offset(-6)
            $0.trailing.equalTo(-4)
            $0.width.equalTo(92)
        }
    }
}


//class CustomButton : UIButton {
//    
//    var indexPath: IndexPath?
//    
//    
//    convenience init(indexPath: IndexPath) {
//        self.init()
//        self.indexPath = indexPath
//    }
//}
//

