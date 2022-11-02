//
//  LaunchViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 06/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

//    @IBOutlet weak var logoImage: UIImageView!
//    @IBOutlet weak var logoCenterYcon: NSLayoutConstraint!
    let highTitle = UILabel()
    let lowTitle = UILabel()
    fileprivate var highConstraint: NSLayoutConstraint?
    fileprivate var lowConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        fadeInTitles()
        let nc = UINavigationController(rootViewController: MainTableViewController())
        self.present(nc, animated: true)
    }
    
    func configureView(){
        highTitle.translatesAutoresizingMaskIntoConstraints = false
        highTitle.text = "STAR WARS"
        highTitle.font = UIFont(name: "DeathStar", size: 40)
        highTitle.textColor = UIColor.swapiYellow
        view.addSubview(highTitle)
//        highTitle.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor, constant: -150).isActive = true
//        highConstraint = highTitle.centerXAnchor.constraint(equalTo: logoImage.centerXAnchor, constant: -400)
        highConstraint?.isActive = true
        highTitle.alpha = 1
        
        lowTitle.translatesAutoresizingMaskIntoConstraints = false
        lowTitle.numberOfLines = 0
        lowTitle.textAlignment = .center
        lowTitle.text = "API"
        lowTitle.font = UIFont(name: "DeathStar", size: 40)
        lowTitle.textColor = UIColor.swapiYellow
        view.addSubview(lowTitle)
//        lowTitle.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor, constant: 180).isActive = true
//        lowConstraint = lowTitle.centerXAnchor.constraint(equalTo: logoImage.centerXAnchor, constant: 400)
        lowConstraint?.isActive = true
        lowTitle.alpha = 1
    }
    
    func fadeInTitles(){
        UIView.animate(withDuration: 0.5) {
            self.lowConstraint?.constant = 0
            self.highConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fadeOutTitles), userInfo: nil, repeats: false)
    }
    
    @objc func fadeOutTitles(){
        UIView.animate(withDuration: 0.5, animations: {
            self.lowConstraint?.constant = -400
            self.highConstraint?.constant = 400
            self.view.layoutIfNeeded()
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
//                self.logoCenterYcon.constant = -800
                self.view.layoutIfNeeded()
            }, completion: { (true) in
//                self.performSegue(withIdentifier: "launch", sender: self)
                let nc = UINavigationController(rootViewController: MainTableViewController())
                self.present(nc, animated: true)
            })
        }
    }
    
    
}

