//
//  SnapsViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snaps: [Snap] = []
    
    @IBAction func logOutUser(_ sender: Any) {
        
        let authentication = Auth.auth()
        
        do{
            try authentication.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error while trying to log user out!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //retrieve logged user
        let authentication = Auth.auth()
        if let idLoggedUser = authentication.currentUser?.uid {
            let database = Database.database().reference()
            let users = database.child("users")
            let snaps = users.child( idLoggedUser ).child("snaps")
            
            //adding an event to monitor when Snaps are ADDED
            snaps.observe(DataEventType.childAdded, with: { (snapshot) in
                //print(snapshot)
                
                //creating object snap
                let data = snapshot.value as? NSDictionary
                let snap = Snap()
                snap.id = snapshot.key
                snap.from = data?["from"] as! String
                snap.fromName = data?["fromName"] as! String
                snap.descriptionImage = data?["descriptionImage"] as! String
                snap.idImage = data?["idImage"] as! String
                snap.urlImage = data?["urlImage"] as! String
                
                self.snaps.append( snap )
                //print(self.snaps)
                self.tableView.reloadData()
            })
            
            //adding an event to monitor when Snaps are EXCLUDED
            snaps.observe(DataEventType.childRemoved, with: { (snapshot) in
                var index = 0
                for snap in self.snaps {
                    if snap.id == snapshot.key {
                        self.snaps.remove(at: index)
                    }
                    index += 1
                }
                
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            return 1
        }
        return totalSnaps
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSnap", for: indexPath)
        
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            cell.textLabel?.text = "You have no snap."
        }else {
            let snap = self.snaps[ indexPath.row ]
            cell.textLabel?.text = snap.fromName
        }
        
        return cell
        
    }
    
    //sending snap object to Details view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[ indexPath.row ]
            self.performSegue( withIdentifier: "detailsSnapSegue", sender: snap )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSnapSegue" {
            let detailsSnapViewController = segue.destination as! DetailsSnapsViewController
            detailsSnapViewController.snap = sender as! Snap
        }
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
