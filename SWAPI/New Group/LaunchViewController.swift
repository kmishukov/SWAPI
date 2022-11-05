//
//  LaunchViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 06/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    private let swImage = UIImageView(frame: .zero)
    private let topTitle = UILabel()
    private let bottomTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .swapiBackground
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fadeInTitles()
    }
    
    private func setupViews(){
        swImage.image = UIImage(named: "stormtrooper")
        view.addSubview(swImage)
        swImage.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 100, height: 100))
            $0.center.equalTo(view)
        }
        
        topTitle.translatesAutoresizingMaskIntoConstraints = false
        topTitle.text = "STAR WARS"
        topTitle.font = UIFont(name: "DeathStar", size: 40)
        topTitle.textColor = UIColor.swapiYellow
        view.addSubview(topTitle)
        topTitle.snp.makeConstraints {
            $0.bottom.equalTo(swImage.snp.top).inset(-40)
            $0.centerX.equalTo(view).offset(-400)
        }
        
        bottomTitle.translatesAutoresizingMaskIntoConstraints = false
        bottomTitle.numberOfLines = 0
        bottomTitle.textAlignment = .center
        bottomTitle.text = "API"
        bottomTitle.font = UIFont(name: "DeathStar", size: 40)
        bottomTitle.textColor = UIColor.swapiYellow
        view.addSubview(bottomTitle)
        bottomTitle.snp.makeConstraints {
            $0.top.equalTo(swImage.snp.bottom).inset(-40)
            $0.centerX.equalTo(view).offset(400)
        }
    }
    
    func fadeInTitles(){
        topTitle.snp.updateConstraints {
            $0.centerX.equalTo(view)
        }
        bottomTitle.snp.updateConstraints {
            $0.centerX.equalTo(view)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fadeOutTitles), userInfo: nil, repeats: false)
    }
    
    @objc func fadeOutTitles(){
        topTitle.snp.updateConstraints {
            $0.centerX.equalTo(view).offset(400)
        }
        bottomTitle.snp.updateConstraints {
            $0.centerX.equalTo(view).offset(-400)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (true) in
            self.swImage.snp.updateConstraints {
                $0.centerY.equalTo(self.view).offset(-1000)
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (true) in
                if let delegate = UIApplication.shared.delegate as? AppDelegate,
                   let window = delegate.window {
                    let mainVC = MainViewController()
                    let navigation = UINavigationController(rootViewController: mainVC)
                    window.rootViewController = navigation
                    let options: UIView.AnimationOptions = .transitionCrossDissolve
                    let duration: TimeInterval = 0.3
                    UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
                }
            })
        }
    }
}

