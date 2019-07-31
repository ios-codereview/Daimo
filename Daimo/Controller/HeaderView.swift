//
//  HeaderView.swift
//  Daimo
//
//  Created by sogih on 14/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    
    fileprivate let cellId = "cell"
    var sectionOfTableView: Int?
    let dateFormatter = DateFormatter()
    let deviceWidth = UIScreen.main.bounds.size.width
    let startDate = Singleton.shared.startDate
    weak var delegate: DeliveryDataProtocol?
    
    let dateTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.date
        label.textColor = .greyishBrown
        return label
    }()
    
    lazy var dateCV: UICollectionView = {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .horizontal
        layer.minimumLineSpacing = 0
        layer.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layer)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .clear
        return cv
    }()
    
    
    override func prepareForReuse() {
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(dateTypeLabel)
        contentView.addSubview(dateCV)
        dateTypeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalToSuperview().offset(18)
            $0.height.equalTo(20)
        }
        dateCV.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(dateTypeLabel.snp_bottomMargin)
            $0.height.equalTo(110)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / deviceWidth)
        var date = Date()
        
        switch sectionOfTableView {
        case 0?:
            date = Calendar.current.date(byAdding: .day, value: index + 1, to: startDate)!
        case 1?:
            switch Calendar.current.dateComponents([.weekday], from: startDate).weekday! {
            case 1: date = Calendar.current.date(byAdding: .day, value: index * 7 - 6 + 1, to: startDate)!
            case 2: date = Calendar.current.date(byAdding: .day, value: index * 7 - 0 + 1, to: startDate)!
            case 3: date = Calendar.current.date(byAdding: .day, value: index * 7 - 1 + 1, to: startDate)!
            case 4: date = Calendar.current.date(byAdding: .day, value: index * 7 - 2 + 1, to: startDate)!
            case 5: date = Calendar.current.date(byAdding: .day, value: index * 7 - 3 + 1, to: startDate)!
            case 6: date = Calendar.current.date(byAdding: .day, value: index * 7 - 4 + 1, to: startDate)!
            case 7: date = Calendar.current.date(byAdding: .day, value: index * 7 - 5 + 1, to: startDate)!
            default: break
            }
        case 2?:
            date = Calendar.current.date(byAdding: .month, value: index-1, to: startDate)!
        case 3?:
            date = Calendar.current.date(byAdding: .year, value: index, to: startDate)!
        default:
            break
        }
        Singleton.shared.currentPoint[sectionOfTableView!] = scrollView.contentOffset
        Singleton.shared.currentDate[sectionOfTableView!] = date
        delegate?.swipeSignal(sectionOfTableView!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItem = 0
        let todayDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        var indexToToday = [0, 0, 0, 0]
        
        switch sectionOfTableView {
        case 0?: numberOfItem = 3650
            indexToToday[0] = Calendar.current.dateComponents([.day], from: startDate, to: todayDate).day!
        case 1?: numberOfItem = 520
            indexToToday[1] = Int(Calendar.current.dateComponents([.day], from: startDate, to: todayDate).day! / 7)
        case 2?: numberOfItem = 120
            indexToToday[2] = Calendar.current.dateComponents([.month], from: startDate, to: todayDate).month! + 1
        case 3?: numberOfItem = 10
            indexToToday[3] = Calendar.current.dateComponents([.year], from: startDate, to: todayDate).year! + 1
        default: break
        }
        DispatchQueue.main.async {
            if Singleton.shared.firstLoadOfSectionHeader[self.sectionOfTableView!] == false {
                Singleton.shared.firstLoadOfSectionHeader[self.sectionOfTableView!] = true
                collectionView.setContentOffset(CGPoint(x: self.deviceWidth * CGFloat(indexToToday[self.sectionOfTableView!]), y: 0), animated: true)
                Singleton.shared.currentPoint[self.sectionOfTableView!] = CGPoint(x: self.deviceWidth * CGFloat(indexToToday[self.sectionOfTableView!]), y: 0)
            } else {
                collectionView.setContentOffset(Singleton.shared.currentPoint[self.sectionOfTableView!], animated: false)
            }
        }
        
//        if Singleton.shared.firstLoadOfSectionHeader[sectionOfTableView!] == false {
//            Singleton.shared.firstLoadOfSectionHeader[sectionOfTableView!] = true
//            collectionView.setContentOffset(CGPoint(x: deviceWidth * CGFloat(indexToToday[sectionOfTableView!]), y: 0), animated: true)
//            Singleton.shared.currentPoint[sectionOfTableView!] = collectionView.contentOffset
//        } else {
//            collectionView.setContentOffset(Singleton.shared.currentPoint[sectionOfTableView!], animated: true)
//        }
        
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DateCollectionViewCell

        var date = Date()
        var dateToString = ""
        
        switch sectionOfTableView {
        case 0?:
            date = Calendar.current.date(byAdding: .day, value: indexPath.row, to: startDate)!
            dateFormatter.setLocalizedDateFormatFromTemplate(("EEEE, MMMMd, yyyy"))
            dateToString = dateFormatter.string(from: date)
            cell.bgView.backgroundColor = .peach
        case 1?:
            date = Calendar.current.date(byAdding: .day, value: indexPath.row * 7, to: startDate)!
            dateFormatter.setLocalizedDateFormatFromTemplate(("EE, MMMd"))
            dateToString = dateFormatter.string(from: date)
            date = Calendar.current.date(byAdding: .day, value: indexPath.row * 7 + 6, to: startDate)!
            dateFormatter.setLocalizedDateFormatFromTemplate("EE, MMMd, yyyy")
            dateToString = "\(dateToString) - \(dateFormatter.string(from: date))"
            cell.bgView.backgroundColor = .paleTeal
        case 2?:
            date = Calendar.current.date(byAdding: .month, value: indexPath.row - 1, to: startDate)!
            dateFormatter.setLocalizedDateFormatFromTemplate(("MMMM, yyyy"))
            dateToString = dateFormatter.string(from: date)
            cell.bgView.backgroundColor = .lightGreyBlue
            
        case 3?:
            date = Calendar.current.date(byAdding: .year, value: indexPath.row, to: startDate)!
            dateFormatter.setLocalizedDateFormatFromTemplate(("yyyy"))
            dateToString = dateFormatter.string(from: date)
            cell.bgView.backgroundColor = .lavenderPink
            
        default:
            break
        }
        
        cell.dateLabel.text = dateToString
        cell.addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        return cell
    }
    
    
}

// MARK:- Event & Action
extension HeaderView {
    @objc func tappedAddButton() {
        delegate?.deliveryData(sectionOfTableView!, Singleton.shared.currentDate[sectionOfTableView!])
    }
}


extension UIColor {
    
    @nonobjc class var peach: UIColor {
        return UIColor(red: 1.0, green: 194.0 / 255.0, blue: 125.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleTeal: UIColor {
        return UIColor(red: 137.0 / 255.0, green: 201.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightGreyBlue: UIColor {
        return UIColor(red: 146.0 / 255.0, green: 169.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lavenderPink: UIColor {
        return UIColor(red: 202.0 / 255.0, green: 155.0 / 255.0, blue: 203.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greyishBrown: UIColor {
        return UIColor(white: 89.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPink: UIColor {
        return UIColor(white: 235.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 163.0 / 255.0, alpha: 1.0)
    }
    
}
