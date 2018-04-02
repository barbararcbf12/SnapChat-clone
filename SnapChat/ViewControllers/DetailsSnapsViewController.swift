//
//  DetailsSnapsViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 01/04/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class DetailsSnapsViewController: UIViewController {

    @IBOutlet weak var imageSnap: UIImageView!
    @IBOutlet weak var detailSnap: UILabel!
    @IBOutlet weak var counterSnap: UILabel!
    
    var snap = Snap()
    var time = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading label
        detailSnap.text = "Loading..."
        
        //getting image's URL and loading image
        let url = URL( string: snap.urlImage )
        imageSnap.sd_setImage( with: url ) { (image, error, cache, url) in
            
            //only after the image is loaded, the counter is started
            if error == nil {
                
                //getting and loading description
                self.detailSnap.text = self.snap.descriptionImage
                
                //Initialize timer
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    
                    //decrease timer in -1
                    self.time -= 1
                    
                    //display on screen
                    self.counterSnap.text = String(self.time)
                    
                    //stop timer when it gets to 0 & Closing screen
                    if self.time == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            }
        }
    }
    
    //excluding snap after closing the view
    override func viewWillDisappear(_ animated: Bool) {
        //print("View was closed!")
        
        //retrieving id of logged user
        let authentication = Auth.auth()
        
        if let idLoggedUser = authentication.currentUser?.uid {
            
            //removing node from database
            let database = Database.database().reference()
            let users = database.child("users")
            let snaps = users.child(idLoggedUser).child("snaps")
            
            snaps.child(snap.id).removeValue()
            
            //removing snap's image from database
            let storage = Storage.storage().reference()
            let images = storage.child("imagens")
            
            images.child( "\(snap.idImage).jpg" ).delete(completion: { (error) in
                if error == nil {
                    print("Success on removing snap!")
                }else {
                    print("An error occured!")
                }
            })
        }
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
