//
//  TableViewController.swift
//  SQLiteSimpleTodoList
//
//  Created by TJ on 2022/06/26.
//

import UIKit
import SQLite3

class TableViewController: UITableViewController {
    var db: OpaquePointer?
    var todoList : [Todo] = []

    @IBOutlet var tvListView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("StudentsData.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS todolist (id INTEGER PRIMARY KEY AUTOINCREMENT, description Text)", nil, nil, nil)
//        tempInsert()
        readValues()
        
        
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let alert = UIAlertController(title: "Todo List", message: "추가할 내용을 입력하세요!", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "추가", style: .default) { ACTION in
            var stmt: OpaquePointer?
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            
            let des = alert.textFields?[0].text
            let queryString = "INSERT INTO todolist (description) VALUES (?)"
            
            sqlite3_prepare(self.db, queryString, -1, &stmt, nil)
            
            sqlite3_bind_text(stmt, 1, des, -1, SQLITE_TRANSIENT)
           
            sqlite3_step(stmt)
            self.readValues()
            self.tvListView.reloadData()
        }
            
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(add)
        alert.addTextField(configurationHandler: nil)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func readValues(){
        todoList.removeAll()
        
        let queryString = "SELECT * FROM todolist"
        var stmt: OpaquePointer?
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        while sqlite3_step(stmt) == SQLITE_ROW{
            let id = sqlite3_column_int(stmt, 0)
            let des = String(cString: sqlite3_column_text(stmt, 1))
            
            print(id, des)
            
            todoList.append(Todo(id: Int(id), description: des))
            
        }
        self.tvListView.reloadData()
    }
    
    func tempInsert(){
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO todolist (description) VALUES (?)"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        sqlite3_bind_text(stmt, 1, "꽃선물 준비", -1, SQLITE_TRANSIENT)
        
        sqlite3_step(stmt)
        
    }
    
    func deleteAction(id:Int) {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM todolist WHERE id = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        sqlite3_bind_int(stmt, 1,Int32(id))
        sqlite3_step(stmt)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        cell.imageView?.image = UIImage(systemName: "paperplane.fill")
        cell.textLabel?.text = todoList[indexPath.row].description

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteAction(id: todoList[indexPath.row].id)
            readValues()
//            todoList[indexPath.row]
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
