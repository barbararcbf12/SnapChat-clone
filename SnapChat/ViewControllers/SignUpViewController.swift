//
//  SignUpViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBAction func createAccount(_ sender: Any) {
        
        //retrieve typed data
        if let emailR = self.email.text {
            if let nameR = self.name.text {
                if let passwordR = self.password.text {
                    if let confirmPasswordR = self.confirmPassword.text{
                        
                        //validate password
                        if passwordR == confirmPasswordR {
                            
                            //validate name
                            if nameR != "" {
                                
                                //create user in Firebase
                                let authentication = Auth.auth()
                                authentication.createUser(withEmail: emailR, password: passwordR, completion: { (user, error) in
                                    if error == nil {
                                        if user == nil {
                                            let alert = Alert(title: "Authentiction error", msg: "Verify typed data and try again.")
                                            self.present( alert.getAlert(), animated: true, completion: nil )
                                        }else {
                                            //seve user to database (Firebase)
                                            let database = Database.database().reference()
                                            let users = database.child("users")
                                            
                                            let userData = [ "name": nameR, "email": emailR ]
                                            users.child( user!.uid ).setValue( userData )
                                            
                                            //direct user to Snaps page list (Home)
                                            self.performSegue(withIdentifier: "signUpLoginSegue", sender: nil)
                                        }
                                    }else {
                                        //get default error msgs
                                        let errorR = error! as NSError
                                        let msgError = errorR.localizedDescription
                                        
                                        let alert = Alert(title: "Authentiction error", msg: msgError)
                                        self.present( alert.getAlert(), animated: true, completion: nil )
                                    }
                                })
                                
                            }else {
                                let alertName = Alert(title: "Incorrect data", msg: "Enter name to continue!")
                                self.present( alertName.getAlert(), animated: true, completion: nil )
                            }
                        
                        }else {
                            let alert = Alert(title: "Incorrect data", msg: "The passwords need to be the same!")
                            self.present( alert.getAlert(), animated: true, completion: nil )
                        }//end validate password
                    }
                }//passwordR
            }//name
        }//email
    }//end func createAccount
    
    
    /*//Alert msg to user
    func showAlertMsg(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction( actionCancel )
        self.present( alert, animated: true, completion: nil )
    }*/
    

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
