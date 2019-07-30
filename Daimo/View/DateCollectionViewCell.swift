//
//  DateCollectionViewCell.swift
//  Daimo
//
//  Created by sogih on 14/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.font = UIFont.date
        label.textColor = .white
        return label
    }()
    let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.tintColor = .white
        return button
    }()
    let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
//        view.layer.shadowColor = UIColor.darkGray.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowRadius = 4.0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.addSubview(dateLabel)
        bgView.addSubview(addButton)
        
        bgView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-6)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIFont {
    
    class var naviTitle: UIFont {
        return UIFont(name: "Champagne&Limousines-Bold", size: 23.0)!
    }
    
    class var date: UIFont {
        return UIFont(name: "Champagne&Limousines-Bold", size: 16.0)!
    }
    
    class var todo: UIFont {
        return UIFont(name: "HaanYGodic23", size: 12.0)!
    }
    
}
