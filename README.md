# swift_sqlite_blob_image


# Swift代码库之如何读取sqlite中存储的图片数据(含源码)



1.  新建个项目

2.  拖拽一个imageview，然后配置IBOutlet
![Jietu20190625-101039@2x.jpg](https://upload-images.jianshu.io/upload_images/41085-175a7b809735ba7d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.  将数据库拖拽到项目中

4. 尝试读取一下数据库

```
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
            let geshi = String(cString: sqlite3_column_text(stmt, 3))
            //let powerrank = sqlite3_column_int(stmt, 2)
            
            //Añandiendo a la lista
            //print("\(id),\(name),\(powerrank)")
            print("\(id),\(tupian),\(geshi)")
        }
        
    }

}


```

## 读取并显示
```
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
```

## 最终效果
![Jietu20190625-103713@2x.jpg](https://upload-images.jianshu.io/upload_images/41085-a7f3ba2df8ad8a85.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



- [请点击，免费阅读《学Swift挣美元》专栏](https://www.jianshu.com/c/5c4b266a8840)
##往期精彩
- [ 赚钱App研究之生成代码app ](https://www.jianshu.com/p/3031b7591f7d)
- [赚钱App研究之格式转换类app](https://www.jianshu.com/p/22b2d9861652)

