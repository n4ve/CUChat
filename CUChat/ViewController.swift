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
  
    
    var user = ""
    var pass = ""
    var swiftyJsonVar = JSON("")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            var nextScene = segue.destination as? TableViewController
            nextScene?.user = user
            nextScene?.session = self.swiftyJsonVar["content"].string
            
        }
    }
    
    

}

