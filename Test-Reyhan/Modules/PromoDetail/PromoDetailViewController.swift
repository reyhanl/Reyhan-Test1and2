//
//  PromoDetailViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 26/03/24.
//

import UIKit
import WebKit

class PromoDetailViewController: UIViewController, CustomTransitionEnabledVC{
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWebView()
    }
    
    func addWebView(){
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func setupUI(url: URL){
        webView.load(.init(url: url))
    }
}
