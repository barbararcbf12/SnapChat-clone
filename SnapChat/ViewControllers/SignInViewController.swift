//
//  SignInViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        //retrieve user
        if let emailR = self.emailLogin.text {
            if let passwordR = self.passwordLogin.text {
                
                //login user in Firebase
                let authentication = Auth.auth()
                authentication.signIn(withEmail: emailR, password: passwordR, completion: { (user, error) in
                    if error == nil {
                        if user == nil {
                            let errorR = error! as NSError
                            let msgError = errorR.localizedDescription
                            self.showAlertMsg(title: "Authentiction error!", msg: msgError)
                            //self.showAlertMsg(title: "Authentiction error", msg: "Verify typed data and try again.")
                        }else {
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    }else {
                        //self.showAlertMsg(title: "Incorrect data", msg: "Verify typed data and try again.")
                        let errorR = error! as NSError
                        let msgError = errorR.localizedDescription
                        self.showAlertMsg(title: "Authentiction error!", msg: msgError)
                    }//end login user
                })
            }
        }
    }

    //Alert msg to user
    func showAlertMsg(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction( actionCancel )
        present( alert, animated: true, completion: nil )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //show navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden( false, animated: false )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
