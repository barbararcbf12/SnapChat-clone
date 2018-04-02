//
//  UsersViewController.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsersViewController: UITableViewController {

    var users: [User] = []
    var descriptionImage = ""
    var urlImage = ""
    var idImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database = Database.database().reference()
        let users = database.child("users")
        
        //add events to users
        users.observe( DataEventType.childAdded) { (snapshot) in
            //print(snapshot)
            
            //Retrieve id logged user
            let authentication = Auth.auth()
            let idLoggedUser = authentication.currentUser?.uid
            
            //convert return to dictionary
            let data = snapshot.value as! NSDictionary
            let emailUser = data["email"] as! String
            let nameUser = data["name"] as! String
            let uidUser = snapshot.key
            
            let user = User( email: emailUser, name: nameUser, uid: uidUser )
            
            //add user to array
            if uidUser != idLoggedUser { //excluding logged user from list of users
                self.users.append( user )
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUsers", for: indexPath)

        // Configure the cell...
        let user = self.users[ indexPath.row ]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = self.users[ indexPath.row ]
        let idSelectedUser = selectedUser.uid
        
        //retrieve database reference
        let database = Database.database().reference()
        let users = database.child("users")
        let snaps = users.child( idSelectedUser ).child("snaps")
        
        //retrieving data from logged user
        let authentication = Auth.auth()
        
        //if possible retrieving data from logged user...
        if let idLoggedUser = authentication.currentUser?.uid {
            
            let loggedUser = users.child(idLoggedUser)
            loggedUser.observeSingleEvent(of: DataEventType.value , with: { (snapshot) in
               //print(snapshot)
                let data = snapshot.value as! NSDictionary
                
                //setting Snap's node structure
                let snap = [
                    "from": data["email"] as! String,
                    "fromName": data["name"] as! String,
                    "descriptionImage": self.descriptionImage,
                    "urlImage": self.urlImage,
                    "idImage": self.idImage
                ]
                
                //creating automatic id to new node
                snaps.childByAutoId().setValue(snap)
                
                self.navigationController?.popToRootViewController(animated: true)
                
            })
            
        }
        
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
