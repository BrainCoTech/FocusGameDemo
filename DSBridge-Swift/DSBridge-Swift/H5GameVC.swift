//
//  H5GameVC.swift
//  FocusFamilyDelta
//
//  Created by Yongle Fu on 2020/5/6.
//  Copyright © 2020 BrainCo. All rights reserved.
//

import WebKit
import dsBridge
import SnapKit

class H5GameVC: UIViewController {
    
    var url: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    convenience init(url: String) {
        self.init(nibName: nil, bundle: nil)
        self.url = url
    }

    func commonInit() {
        self.hidesBottomBarWhenPushed = true
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    private let estimatedProgress = "estimatedProgress"
    var needRemoveObserver = false
    deinit {
        if needRemoveObserver {
            webView.removeObserver(self, forKeyPath: estimatedProgress)
        }
    }
    
    private var needReload = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needReload {
            webView.reload()
            needReload = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        needReload = true
    }
    
    func loadData() {
        progressView.progress = 0

        if let url = self.url {
            print(url)
            let request = URLRequest(url: URL(string: url)!)
            //var request = URLRequest(url: URL(string: url)!)
            //request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            webView.load(request)
        }
    }
    
    func actionBack() {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        
//        if let block = backBlock {
//            block()
//        } else {
//            super.actionBack()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = gameInit
    }
    
    private lazy var gameInit: Int = {
        setupUI()
        return 0
    }()
    
    func setupUI() {
        view.backgroundColor = .white
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(2)
        })
        
        view.insertSubview(webView, at: 0)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(progressView.snp.bottom)
        }
        webView.addJavascriptObject(H5GameAPI.shared, namespace: nil)

        #if DEBUG
        webView.setDebugMode(true)
        webView.customJavascriptDialogLabelTitles(["alertTitle":"Notification", "alertBtn":"OK"])
        #endif
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == estimatedProgress {
            needRemoveObserver = true
            if let newValue = change?[.newKey] as? Float {
                print("estimatedProgress changed: \(newValue)")
                
                progressView.alpha = 1.0
                let animated: Bool = webView.estimatedProgress > Double(progressView.progress)
                progressView.setProgress(newValue, animated: animated)
                
                // Once complete, fade out
                if newValue >= 1.0 {
                    //                    if !NetworkManager.isReachable {
                    //                        addFailedView()
                    //                        return
                    //                    }
                    
//                    delay(0.5) { [weak self] in
//                        self?.loaded = true
//                    }
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.progressView.alpha = 0.0
                    }) { finished in
                        self.progressView.setProgress(0.0, animated: false)
                    }
                }
            }
        }
    }
    
//    func shareWebImage() {
//        webView.scrollView.swContentCapture { [weak self] image in
//            if let shareImage = image, let `self` = self {
//                self.shareCurrentScreen(image: shareImage, sourceView: self.navBar.rightBtn)
//            }
//        }
//    }
//
//    @objc func actionShare() {
//        let vc = ShareVC()
//        UIViewController.presentAlert(vc)
//        if self.url == FocusNowWeb.activityEntry.url.absoluteString {
//            FSAnalytics.event("7Conver-share")
//        } else if self.url == FocusNowWeb.activityReport.url.absoluteString {
//            FSAnalytics.event("7report-share")
//        }
//    }
    
//    func setTitle(_ title: String) {
//        navBar.titleLabel.text = title
//    }
    
    // MARK:- getters
    
    lazy var webView: DWKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = DWKWebView(frame: self.view.bounds, configuration: webConfiguration)
        webView.navigationDelegate = self
//        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: estimatedProgress, options: [.new], context: nil)
        
        return webView
    }()
    
//    lazy var navBar: BaseNavBar = {
//        let navBar = BaseNavBar(style: isBlack ? .black : .white)
//        navBar.titleLabel.text = self.title
//        navBar.addBackBtn(target: self, action: #selector(actionBack))
//        if shareBlock != nil {
//            navBar.addShareBtn(target: self, action: #selector(actionShare))
//        }
//        return navBar
//    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .orange
        view.trackTintColor = .white
        view.alpha = 0
        return view
    }()
}

extension H5GameVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _print("")
//        self.onLoadData(code: NetworkManager.isReachable ? .ok : .networkConnectionLost)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _print("")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _print("")
//        self.onLoadData(code: .badURL)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if challenge.previousFailureCount == 0, let serverTrust = challenge.protectionSpace.serverTrust {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
}


func delay(_ delay: Double, closure:@escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure)
}

func _print(_ str: String) {
    
}
