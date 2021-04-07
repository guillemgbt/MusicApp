//
//  MainViewController.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/20/21.
//

import UIKit

class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentSignIn))
        
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    @objc func presentSignIn() {
        let vc = UINavigationController(rootViewController: LoginViewController())
        present(vc, animated: true, completion: nil)
    }
}
