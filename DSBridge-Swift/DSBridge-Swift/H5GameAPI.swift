//
//  H5GameAPI.swift
//  FocusFamilyDelta
//
//  Created by Yongle Fu on 2020/5/6.
//  Copyright © 2020 BrainCo. All rights reserved.
//

import dsBridge
import WebKit
import SwiftyJSON

@objcMembers
class H5GameAPI: NSObject {
    typealias JSAttentionHandler = (NSNumber) -> Void
    
    static let shared = H5GameAPI()

    var attentionTimer: Timer?
    var attention: Double = 50.0
    var attentionHandler: JSAttentionHandler?
    func mockAttention() {
        if attentionTimer != nil { return }
        mockAttentionRandom()
    }
    
    func onAttention(_ attention: Double) {
        self.attention = attention
        attentionHandler?(NSNumber(value: attention.clamp(toMinimum: 0.0, maximum: 99.0) + Double.random(in: (0...1))))
    }
    
    func mockAttentionLinear() {
        let delta: Double = 5
        var offset: Double = delta
        
        self.onAttention(50)
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] (timer) in
            guard let `self` = self else { timer.invalidate(); return }
            if self.attention + offset > 100 {
                offset = -delta
            } else if self.attention + offset < 0 {
                offset = delta
            }
            
            self.attention += offset
            self.onAttention(self.attention)
        }
        RunLoop.current.add(timer, forMode: .common)
        attentionTimer = timer
    }
    
    func mockAttentionRandom() {
        let isMedition = false
        self.onAttention(isMedition ? 10 : 60)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let `self` = self else { timer.invalidate(); return }
            var new: Double
            if isMedition {
                let random = Double((-5...5).randomElement()!)
                new = self.attention + random
            } else {
                let random = Double((-10...10).randomElement()!)
                new = self.attention + random
            }
            //new -= Double((1...10).randomElement()!)
            //let new = Double((5...100).randomElement()!)
            self.onAttention(new)
        })
        RunLoop.current.add(timer, forMode: .common)
        attentionTimer = timer
    }
    
    func getGameInfo(_ arg: [String: Any], _ completion: ([String: Any]) -> Void) {
        let lvFrom = 5
        let lvTo = 5
        let duration = 30
        let params = ["lvFrom": lvFrom, "lvTo": lvTo, "duration": duration]
        completion(params)
    }
    
    func getUserInfo(_ arg: [String: Any], _ completion: ([String: Any]) -> Void) {
        let name = "Test_001";
        let avatar = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594895469817&di=72061eb0f251672b08300559c17a6737&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201802%2F27%2F20180227232444_omtjy.jpeg";
        let params = ["name": name, "avatar": avatar]
        completion(params)
    }
    
    func getUserAttention(_ arg: [String: Any], _ handler: @escaping JSAttentionHandler) {
        self.attentionHandler = handler
        mockAttention()
    }
    
    func onStart(_ arg: [String: Any]) -> String {
        return "onStart, call"
    }
    
    func onFinish(_ arg: [String: Any]) -> String {
        return "onFinish, " + toJsonString(arg)
    }
    
    func toJsonString(_ arg: [String: Any]) -> String {
        //        let json = toJsonString(params)
               //        completion(json, true)
        return JSON(arg).rawString(options: JSONSerialization.WritingOptions(rawValue: 0)) ?? ""
    }
}

//extension H5GameAPI: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        _print("")
////        screenShootBlock?(true)
//    }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        _print("")
////        screenShootBlock?(false)
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        _print("")
////        screenShootBlock?(false)
//    }
//
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//            if challenge.previousFailureCount == 0, let serverTrust = challenge.protectionSpace.serverTrust {
//                completionHandler(.useCredential, URLCredential(trust: serverTrust))
//            } else {
//                completionHandler(.cancelAuthenticationChallenge, nil)
//            }
//        }
//    } */
//}

extension Comparable {
    func clamp(toMinimum minimum: Self, maximum: Self) -> Self {
//        assert(maximum >= minimum, "Maximum clamp value can't be higher than the minimum")
        if maximum < minimum {
            return minimum
        }
        if self < minimum {
            return minimum
        } else if self > maximum {
            return maximum
        } else {
            return self
        }
    }
}
