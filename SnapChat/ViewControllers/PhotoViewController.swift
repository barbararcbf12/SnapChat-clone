//
//  PhotoViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseStorage

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var idImage = NSUUID().uuidString
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var labelPicture: UITextField!
    @IBOutlet weak var nextShow: UIButton!
    
    @IBAction func nextButton(_ sender: Any) {
        
        self.nextShow.isEnabled = false
        self.nextShow.setTitle("Loading...", for: .normal)
        
        let storage = Storage.storage().reference()
        let images = storage.child("imagens") //create images folder
        
        //retrieve image
        if let selectedImage = picture.image {
            if let imageData = UIImageJPEGRepresentation(selectedImage, 0.1) {
                images.child("\(self.idImage).jpg").putData(imageData, metadata: nil, completion: { (metaDados, error ) in
                    if error == nil {
                        //let alert = Alert(title: "Success", msg: "Picture successfully uploaded.")
                        //self.present( alert.getAlert(), animated: true, completion: nil )
                        
                        //get picture url
                        let urlPicture = metaDados?.downloadURL()?.absoluteString
                        self.performSegue( withIdentifier: "selectUserSegue", sender: urlPicture )
                        
                        self.nextShow.isEnabled = true
                        self.nextShow.setTitle("Next", for: .normal)
                    }else {
                        //print("Failure!")
                        let alert = Alert(title: "Upload filed!", msg: "Error while trying to upload picture, plase try again")
                        self.present( alert.getAlert(), animated: true, completion: nil )
                    }
                })
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectUserSegue" {
            let userViewController = segue.destination as! UsersViewController
            
            userViewController.descriptionImage = self.labelPicture.text!
            userViewController.urlImage = sender as! String
            userViewController.idImage = self.idImage
        }
    }
    
    
    @IBAction func camera(_ sender: Any) {
        //connect to photo album
        imagePicker.sourceType = .camera //take picture
        //imagePicker.sourceType = .savedPhotosAlbum //select from gallery
        present( imagePicker, animated: true, completion: nil )
    }
    
    //Closing keyboard when clicking/tapping outside textbox
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info)
        let retrievedPicture = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        picture.image = retrievedPicture
        
        //enable button Next
        self.nextShow.isEnabled = true
        self.nextShow.backgroundColor = UIColor( red: 0.553, green: 0.369, blue: 0.749, alpha: 1 )
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        //disable button Next
        nextShow.isEnabled = false
        nextShow.backgroundColor = UIColor.gray
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
