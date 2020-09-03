//
//  ViewController.swift
//  DSBridge-Swift
//
//  Created by Yongle Fu on 2020/7/16.
//  Copyright © 2020 BrainCo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .yellow
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }
        
        let titles = ["JSCallNative", "H5CallNative", "Embedded View"]
        for i in 0..<titles.count {
            let btn = UIButton()
            btn.tag = i
            btn.setTitleColor(.red, for: .normal)
            btn.setTitle(titles[i], for: .normal)
            btn.addTarget(self, action: #selector(actionBtn(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(btn)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc func actionBtn(_ btn: UIButton) {
        let tag = btn.tag
        let vc = H5GameVC()
        
        switch tag {
            case 0:
                guard let url = Bundle.main.url(forResource: "test", withExtension: "html")?.absoluteString else { return }
                vc.url = url
            case 1:
                vc.url = "http://cdn.7tiao.net/zzgame/game1/"
                vc.url = "http://172.16.215.185:8000/"
//                vc.url = "http://www.baidu.com"
//                vc.url = "http://127.0.0.1/web-mobile/"
//                vc.url = "http://172.16.122.103/web-mobile/"
            default:
                self.addVC(); return;
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    func addVC() {
        let courseVC = H5GameVC()
        courseVC.url = "http://www.baidu.com"
        self.addChild(courseVC)
        view.addSubview(courseVC.view)
        self.addChild(courseVC)
        courseVC.view.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(540.0/810.0)
            make.width.equalTo(courseVC.view.snp.height).multipliedBy(16.0/9.0)
            make.center.equalToSuperview()
        }
    }
}

