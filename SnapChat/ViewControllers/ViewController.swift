//
//  ViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authentication = Auth.auth()
        
        do{
            try authentication.signOut()
        } catch {
            print("Error while trying to log user out!")
        }
        
        authentication.addStateDidChangeListener { (authentication, user) in
            if user != nil {
                self.performSegue(withIdentifier: "autoLoginSegue", sender: nil)
            }
        }
    }
    
    //hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden( true, animated: false )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

