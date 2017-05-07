//
//  ChatViewController.swift
//  CUChat
//
//  Created by Navee Sratthatad on 5/7/2560 BE.
//  Copyright © 2560 Navee Sratthatad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var message: UITextField!
    var opponent:String?
    var listChatAll = NSMutableArray()
    var listChat = NSMutableArray()
    var swiftyJsonVar = JSON("")
    var js :Dictionary<String,String> = Dictionary()
    private var contacts = [Contact]()
    
    @IBOutlet var table: UITableView!
    
    private func getMessage(){
        listChatAll = []
        listChat = []
        let url : String = "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api%2FgetMessage"
        
        let param  : [String: String] = [
            "sessionid" : contacts[0].session,
            "seqno" : "0",
            "limit" : "1000"

        ]
        Alamofire.request(url,method : .post, parameters: param).responseJSON { response in
            self.swiftyJsonVar = JSON(response.result.value!)
            self.listChatAll = self.swiftyJsonVar["content"].arrayObject as! NSMutableArray
            for var i in 0..<self.listChatAll.count
            {
                self.js = self.listChatAll[i] as! Dictionary
                var seq = self.js["seqno"]
                var from = self.js["from"]
                var to = self.js["to"]
                var message = self.js["message"]
                var datetime = self.js["datetime"]
                if ((self.contacts[0].username == from &&
                    self.opponent == to )||(
                    self.contacts[0].username == to &&
                    self.opponent == from))
                {
                
                    self.listChat.insert(self.listChatAll[i], at: self.listChat.count)
                   
                }
                
                
            }
            //(responseData) -> Void
            
            self.table.reloadData()
        }
        
        
    }
    
   
    @IBAction func postMessage(_ sender: Any) {
        let url : String = "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api%2FpostMessage"
        
        let param  : [String: String] = [
            "sessionid" : contacts[0].session,
            "targetname" : opponent!,
            "message"  : message.text!
        ]
        
        Alamofire.request(url,method : .post, parameters: param).responseJSON { response in
            //self.swiftyJsonVar = JSON(response.result.value!)
            //self.listChatAll = self.swiftyJsonVar["content"].arrayObject as! Array<String>
            //(responseData) -> Void
            self.message.text = ""
            self.getMessage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        contacts = CuDatabase.instance.getContacts()
        self.title = opponent
        getMessage()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        self.js = self.listChat[indexPath.row] as! Dictionary
        var seq = self.js["seqno"]
        var from = self.js["from"]
        var to = self.js["to"]
        var message = self.js["message"]
        var datetime = self.js["datetime"]

        if(indexPath.section == 0 ){
            if(from == contacts[0].username){
                    cell.textLabel?.numberOfLines = 0;
                    cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell.textLabel?.textAlignment = NSTextAlignment.right
                    cell.textLabel?.text = message!+"\n"+datetime!
              
                
               
            }
            else{
                    cell.textLabel?.numberOfLines = 0;
                    cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell.textLabel?.textAlignment = NSTextAlignment.left
                    cell.textLabel?.text = message!+"\n"+datetime!
                           }
        
        }
        
        return cell
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
