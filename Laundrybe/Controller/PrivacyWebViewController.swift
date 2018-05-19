//
//  PrivacyWebViewController.swift
//  Laundrybe
//
//  Created by Sukumar Anup Sukumaran on 10/01/18.
//  Copyright © 2018 Sukumar Anup Sukumaran. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class PrivacyWebViewController: UIViewController, NVActivityIndicatorViewable, WKUIDelegate,  WKNavigationDelegate, UIScrollViewDelegate {
    
    
//    @IBOutlet weak var privacyWeb: WKWebView!
    
     @IBOutlet var mainView: UIView!
    
     var webView: WKWebView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      giveGradientNav()
        
     self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // loadWebUrl()
    }
    
    override func viewDidLayoutSubviews() {
         callingWebView()
        
    }
    
    func callingWebView() {
        
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//         webView.uiDelegate = self
        
        webView = WKWebView(frame: CGRect(x: 0, y: 20, width: self.mainView.frame.width, height: self.mainView.frame.height - 20))
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        
        mainView.addSubview(webView)
        mainView.sendSubview(toBack: webView)
         loadWebUrl()
        
        
        
      
//        view = webView
//
//        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
       // loadWebUrl()
    
    }
    
    
    func giveGradientNav(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [ NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont(name: "Arial Rounded MT Bold", size: 18.0)!  ]
        //UIFont(name: "Questrial-Regular")!
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        self.navigationController?.navigationBar.setBackgroundImage(imageLayerForGradientBackground(), for: UIBarMetrics.default)
        
    }
    
    
    func loadWebUrl() {
        //http://shahiltp.000webhostapp.com/privacy_policy%20(1).html
        let url = URL(string: "http://shahiltp.000webhostapp.com/privacy_policy%20(1).html")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
        
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //print(error.localizedDescription)
        print("Error = \(error.localizedDescription)")
        self.stopAnimating()
//        activityIndicator.stopAnimating()
//        self.visualEffectView.isHidden = true
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // self.MainView.bringSubview(toFront: activityIndicator)
        
        
        
//        activityIndicator.startAnimating()
//        self.visualEffectView.isHidden = false
//
//
//        self.visualEffectView.effect = self.effect
        
        
        print("IndicatorStartAnimating")
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        self.stopAnimating()
//        activityIndicator.stopAnimating()
//        print("IndicatorStopedAnimating")
//        self.visualEffectView.isHidden = true
//        print("VisualEffectIsNotVisible")
//
        
    }
    
    
    // keeps the page from scrolling horizontally
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            var offset = scrollView.contentOffset
            offset.x = 0
            scrollView.contentOffset = offset
        }
    }
    

//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("WEBGiven")
//
//        if keyPath == "estimatedProgress" {
//
//        self.startAnimating(message: "", type: NVActivityIndicatorType.ballSpinFadeLoader, color: .white, padding: 5)
//
//            if self.webView.estimatedProgress*100 == 100 {
//                self.stopAnimating()
//            }
//
//
//        }
//    }
//
//    deinit {
//        self.webView.removeObserver(self, forKeyPath:  #keyPath(WKWebView.estimatedProgress), context: nil)
//
//    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func MenuAction(_ sender: UIBarButtonItem) {
        
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
        
    }
    
    private func imageLayerForGradientBackground() -> UIImage {
        
        var updatedFrame = self.navigationController?.navigationBar.bounds
        // take into account the status bar
        
        if UIScreen.main.nativeBounds.height == 2436 {
            updatedFrame?.size.height += 50
            print("IphoneX😇")
        }else{
            updatedFrame?.size.height += 20
            print("SomeOther123")
        }
        let layer = GrandientClass.gradientLayerForBounds(bounds: updatedFrame!)
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

}
