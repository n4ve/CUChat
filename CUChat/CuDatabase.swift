//
//  CuDatabase.swift
//  CUChat
//
//  Created by Navee Sratthatad on 5/7/2560 BE.
//  Copyright © 2560 Navee Sratthatad. All rights reserved.
//

import SQLite

class CuDatabase {
    
    private let contacts = Table("contacts")
    private let id = Expression<Int64>("id")
    private let session = Expression<String>("session")
    private let username = Expression<String>("name")
    
    
    static let instance = CuDatabase()
    private let db: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/CuDatabase.sqlite3")
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createTable() {
        do {
            try db!.run(contacts.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(session)
                table.column(username)
               
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func addContact(cusername: String, csession: String) -> Int64? {
        do {
            let insert = contacts.insert(session <- csession,username <- cusername)
            let id = try db!.run(insert)
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    func getContacts() -> [Contact] {
        var contacts = [Contact]()
        
        do {
            for contact in try db!.prepare(self.contacts) {
                contacts.append(Contact(
                    id: contact[id],
                    session: contact[session],
                    username: contact[username]))
            }
        } catch {
            print("Select failed")
        }
        
        return contacts
    }
    
    func deleteContact() -> Bool {
        do {
            let contact = contacts
            try db!.run(contact.delete())
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
    func dropTable(){
        do {
            try db!.run(contacts.drop(ifExists: true))
        }
        catch {
            print("Drop failed")
        }
    }
    
    
}
