//
//  LoginViewController.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/18/21.
//

import UIKit
import WebKit
import Combine

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    let viewModel = LoginViewModel()
    
    var webView: WKWebView!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setWebView()
        bindView()
    }
    
    private func setNavigationBar() {
        let button = UIBarButtonItem(barButtonSystemItem: .close,
                                     target: self,
                                     action: #selector(onCloseAction))
        
        navigationItem.setRightBarButton(button, animated: true)
        
        let check = UIBarButtonItem(barButtonSystemItem: .search,
                                    target: self,
                                    action: #selector(onCheckAction))
        
        navigationItem.setLeftBarButton(check, animated: true)
    }
    
    @objc private func onCloseAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onCheckAction() {
        let c = CredentialsManager()
        let user = c.currentUser
        print(user?.name ?? "")
    }
    
    private func setWebView() {
        webView.load(URLRequest(url: viewModel.loginPageURL))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func bindView() {
        bindMessage()
        bindShouldDismiss()
    }
    
    private func bindMessage() {
        viewModel
            .message
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (message) in
                self?.show(message: message)
            }
            .store(in: &subscriptions)
    }
    
    private func bindShouldDismiss() {
        viewModel
            .shouldDismiss
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .store(in: &subscriptions)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        viewModel.handleError(error)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if viewModel.isAccessTokenURL(url: webView.url) {
            viewModel.handleRedirectCodeURL(webView.url)
        }
    }
}
