//
//  HeaderView.swift
//  Daimo
//
//  Created by sogih on 14/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//

import UIKit

// Review: [Refactoring] Controller folder 에 위치하는 것보단 View folder 에 위치하는게 좋지 않을까요?
class HeaderView: UITableViewHeaderFooterView {
    
    
    fileprivate let cellId = "cell"
    var sectionOfTableView: Int?
    // Review: [성능] DateFormatFactory 를 통해서 제공하는 건 어떨까요?
    // 매번 생성하는 것보다 싱글톤으로 제공한다면 매번 생성을 하지 않아도 될 것 같습니다.
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
        
        // Review: [Refactroing] Optional 로 Case를 비교하는 것 보다 unwrap 이후 비교하는 건 어떨가요?
        guard let _ = sectionOfTableView else { return }
        switch sectionOfTableView {
        case 0?:
            date = Calendar.current.date(byAdding: .day, value: index, to: startDate)!
        case 1?:
            // Review: [Refactroing] forced unwrap 은 위험합니다.
            switch Calendar.current.dateComponents([.weekday], from: startDate).weekday! {
            case 1: date = Calendar.current.date(byAdding: .day, value: index * 7 - 6, to: startDate)!
            case 2: date = Calendar.current.date(byAdding: .day, value: index * 7 - 0, to: startDate)!
            case 3: date = Calendar.current.date(byAdding: .day, value: index * 7 - 1, to: startDate)!
            case 4: date = Calendar.current.date(byAdding: .day, value: index * 7 - 2, to: startDate)!
            case 5: date = Calendar.current.date(byAdding: .day, value: index * 7 - 3, to: startDate)!
            case 6: date = Calendar.current.date(byAdding: .day, value: index * 7 - 4, to: startDate)!
            case 7: date = Calendar.current.date(byAdding: .day, value: index * 7 - 5, to: startDate)!
            default: break
            }
        case 2?:
            date = Calendar.current.date(byAdding: .month, value: index, to: startDate)!
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
            indexToToday[2] = Calendar.current.dateComponents([.month], from: startDate, to: todayDate).month!
        case 3?: numberOfItem = 10
            indexToToday[3] = Calendar.current.dateComponents([.year], from: startDate, to: todayDate).year!
        default: break
        }
        // Review: [Refactroing] item의 갯수만 반환해야 하는 함수에서 UI Update를 하는 것 좋지 않은 것 같습니다.
        // func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
        // 여기에서 하는 것을 고려해 보면 어떨까요?
        DispatchQueue.main.async {
            if Singleton.shared.firstLoadOfSectionHeader[self.sectionOfTableView!] == false {
                Singleton.shared.firstLoadOfSectionHeader[self.sectionOfTableView!] = true
                collectionView.setContentOffset(CGPoint(x: self.deviceWidth * CGFloat(indexToToday[self.sectionOfTableView!]), y: 0), animated: true)
                Singleton.shared.currentPoint[self.sectionOfTableView!] = CGPoint(x: self.deviceWidth * CGFloat(indexToToday[self.sectionOfTableView!]), y: 0)
            } else {
                collectionView.setContentOffset(Singleton.shared.currentPoint[self.sectionOfTableView!], animated: false)
            }
        }
        
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
            date = Calendar.current.date(byAdding: .month, value: indexPath.row, to: startDate)!
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //animation
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            collectionView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                collectionView.transform = .identity
            }, completion: nil)
        }
        
        delegate?.deliveryData(sectionOfTableView!, Singleton.shared.currentDate[sectionOfTableView!])
    }
}




// MARK:- Event & Action
extension HeaderView {
}


extension UIColor {
    
    @nonobjc class var peach: UIColor {
        // Review: [Refactoring] colorLiteral을 사용하는건 어떤가요?
        // #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
