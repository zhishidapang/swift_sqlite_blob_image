//
//  ViewController.swift
//  swift_sqlite_blob_image
//
//  Created by cf on 2019/6/25.
//  Copyright © 2019 cf. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    var db: OpaquePointer?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initDB()
        readData()
    }
    
   
    func initDB() {
        //the database file
        let dbPath = Bundle.main.path(forResource: "kx.db", ofType: nil)
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroesDatabase.sqlite")
        
        let filePath = fileURL.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE")
            //try! fileManager.removeItem(atPath: filePath)
            
        } else {
            print("FILE NOT AVAILABLE")
            try! fileManager.copyItem(atPath: dbPath!, toPath: filePath)
            
        }
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //creating table
        
        print(fileURL)
    }
    
   
    func readData(){
        //Query de SELECT
        let queryString = "SELECT * FROM mword"
        
        //Statement pointer
        var stmt:OpaquePointer?
        
        //Prearando el query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //Leyendo registros
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let tupian = String(cString: sqlite3_column_text(stmt, 1))
            let geshi = String(cString: sqlite3_column_text(stmt, 2))
            //let powerrank = sqlite3_column_int(stmt, 2)
            if let dataBlob = sqlite3_column_blob(stmt, 3){
                let dataBlobLength = sqlite3_column_bytes(stmt, 3)
                let data = Data(bytes: dataBlob, count: Int(dataBlobLength))
                imageView.image=UIImage(data: data)
            }
            //Añandiendo a la lista
            //print("\(id),\(name),\(powerrank)")
            print("\(id),\(tupian),\(geshi)")
        }
        
    }

}

