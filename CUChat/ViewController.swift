//
//  ViewController.swift
//  CUChat
//
//  Created by Navee Sratthatad on 5/6/2560 BE.
//  Copyright © 2560 Navee Sratthatad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ViewController: UIViewController {

    @IBOutlet var Username: UITextField!
    
    @IBOutlet var Password: UITextField!
    
   
    
    private var contacts = [Contact]()
    private var selectedContact: Int?
    
    var user = ""
    var pass = ""
    var swiftyJsonVar = JSON("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = CuDatabase.instance.getContacts()
        if(contacts.count == 1){
            performSegue(withIdentifier: "skipIdentifier", sender: self)
        }
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)        // Do any additional setup after loading the view, typically from a nib.
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CuDatabase.instance.deleteContact()
    }

    

    @IBAction func LoginAction(_ sender: Any) {
        
       
        
        
        let url : String = "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api%2FsignIn"
        
        user = Username.text!
        pass = Password.text!
        
        let param : [String: String] = [
        
            "username" : user,
            "password" : pass
        ]
        
        Alamofire.request(url,method : .post, parameters: param).responseJSON { (responseData) -> Void  in
                
                self.swiftyJsonVar = JSON(responseData.result.value!)
            
                if(self.swiftyJsonVar["type"] == "error"){
                    let alert = UIAlertController(title: "Error", message: "Invalid Username/Password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.performSegue(withIdentifier: "loginIdentifier", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginIdentifier"){
            if  let id = CuDatabase.instance.addContact(cusername: user,csession: self.swiftyJsonVar["content"].string!) {
                let contact = Contact(id: id, session:self.swiftyJsonVar["content"].string!, username: user)
                contacts.append(contact)
                }
            }
            var nextScene = segue.destination as? TableViewController
            //nextScene?.user = user
            //nextScene?.session = self.swiftyJsonVar["content"].string
        
        }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    }
    
    



