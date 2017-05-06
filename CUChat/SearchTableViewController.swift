//
//  SearchTableViewController.swift
//  CUChat
//
//  Created by Navee Sratthatad on 5/6/2560 BE.
//  Copyright © 2560 Navee Sratthatad. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchTableViewController: UITableViewController {
    
    var user:String?
    var session:String!
    var swiftyJsonVar = JSON("")
    var listName = Array<String>()
    
    @IBOutlet var nameEditext: UITextField!
    private func fetchContact(){
        if (nameEditext.text?.isEmpty)!{
            let alert = UIAlertController(title: "Error", message: "Please specify keyword", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let url : String = "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api%2FsearchUser"
            let param : [String: String] = [
                
                "sessionid" : session,
                "keyword" : nameEditext.text!
                
            ]
            Alamofire.request(url,method : .post, parameters: param).responseJSON { response in
                self.swiftyJsonVar = JSON(response.result.value!)
                self.listName = self.swiftyJsonVar["content"].arrayObject as! Array<String>
                //(responseData) -> Void
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func SearchAction(_ sender: Any) {
        print(session)
        fetchContact()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if (indexPath.section == 0){
            cell.textLabel?.text = listName[indexPath.row]
        }
        
        // Configure the cell...
    

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0){
            
            let url : String = "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api%2FaddContact"
            let param : [String: String] = [
                
                "sessionid" : session,
                "username" : listName[indexPath.row]
                
            ]
            Alamofire.request(url,method : .post, parameters: param).responseJSON { response in
                let alert = UIAlertController(title: "Success", message: "Added friend Successful", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
    }
    }
    
}
