//
//  SplashViewController.swift
//  Daimo
//
//  Created by sogih on 31/07/2019.
//  Copyright © 2019 sogih. All rights reserved.
//


import UIKit

class SplashViewController: UIViewController {
    
    let deviceWidth = UIScreen.main.bounds.size.width
    let deviceHeight = UIScreen.main.bounds.size.height
    
    let lightTitle: UIImageView = {
        // Review: [Refactoring] Device 크기가 아니라 부모의 frame을 기준으로 하는 건 어떤지요?
        // lightTitle.frame = CGRect(x: self.view.bounds.width/2-36, y: self.view.bounds.height/2-10, width: 75, height: 20)
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.frame = CGRect(x: deviceWidth/2-36, y: deviceHeight/2-10, width: 75, height: 20)
        view.image = UIImage(named: "LightTitle")
        return view
    }()
    
    let leading: UIImageView = {
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.frame = CGRect(x: deviceWidth/2-36, y: deviceHeight, width: 16, height: 17)
        view.image = UIImage(named: "leading")
        return view
    }()
    
    let bottom: UIImageView = {
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.frame = CGRect(x: deviceWidth/2-36+16+2, y: 0, width: 37, height: 17)
        view.image = UIImage(named: "bottom")
        return view
    }()
    
    let trailing: UIImageView = {
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.frame = CGRect(x: deviceWidth, y: deviceHeight/2 - 10 - 12 - 17, width: 17, height: 17)
        view.image = UIImage(named: "trailing")
        return view
    }()
    
    let top: UIImageView = {
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.frame = CGRect(x: 0, y: deviceHeight/2 - 10 - 12 - 17 - 2 - 35, width: 74, height: 35)
        view.image = UIImage(named: "top")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(lightTitle)
        view.addSubview(leading)
        view.addSubview(bottom)
        view.addSubview(trailing)
        view.addSubview(top)
        
        UIView.animate(withDuration: 0.8, animations: {
            self.leading.frame.origin.y = self.deviceHeight/2 - 10 - 12 - 17
        }, completion: nil)
        UIView.animate(withDuration: 0.9, animations: {
            self.bottom.frame.origin.y = self.deviceHeight/2 - 10 - 12 - 17
        }, completion: { (done) in

        
        
            UIView.transition(with: self.lightTitle, duration: 0.75, options: .transitionCrossDissolve, animations: {
                self.lightTitle.image = UIImage.init(named: "DarkTitle")
            }, completion: { (done) in
                let mainVC = UINavigationController(rootViewController: TodoTableViewController())
                self.present(mainVC, animated: true, completion: nil)
            })
        
            
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.trailing.frame.origin.x = self.deviceWidth/2-36+16+2+37+2
        }, completion: nil)
        UIView.animate(withDuration: 0.4, animations: {
            self.top.frame.origin.x = self.deviceWidth/2-36
        }, completion: nil)
        
    }
    
    
}

