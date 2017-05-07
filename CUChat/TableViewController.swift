//
//  TableViewController.swift
//  CUChat
//
//  Created by Navee Sratthatad on 5/6/2560 BE.
//  Copyright © 2560 Navee Sratthatad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {
    
    var user:String?
    var session:String?
    var index:Int?
    var swiftyJsonVar = JSON("")
    var listName = Array<String>()
    private var contacts = [Contact]()
    
    private func fetchContact(){
        let url : String = "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api%2FgetContact"
        let param : [String: String] = [
            
            "sessionid" : contacts[0].session
           
        ]
        Alamofire.request(url,method : .post, parameters: param).responseJSON { response in
            self.swiftyJsonVar = JSON(response.result.value!)
            self.listName = self.swiftyJsonVar["content"].arrayObject as! Array<String>
            //(responseData) -> Void
            self.tableView.reloadData()
        }
        
 
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = CuDatabase.instance.getContacts()
        fetchContact()
        
    }

    @IBAction func AddAction(_ sender: Any) {
        
        performSegue(withIdentifier: "searchIdentifier", sender: self)
    
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
            index = indexPath.row
            performSegue(withIdentifier: "chatIdentifier", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchIdentifier") {
            var nextScene = segue.destination as? SearchTableViewController
           // nextScene?.user = user
            //nextScene?.session = session
        }
        if (segue.identifier == "chatIdentifier"){
            var nextScene = segue.destination as? ChatViewController
            nextScene?.opponent = listName[index!]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContact()
    }
}
