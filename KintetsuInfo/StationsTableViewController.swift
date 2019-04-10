//
//  StationsTableViewController.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/10/09.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit
import RealmSwift

class StationsTableViewController: UITableViewController {
    
    var favoliteList = [(name: String,direction:String,grade:String,date:Date,gradeInt:Int)]()//Int...realm削除チェック用
    let emptyLabel = UILabel()
    override func viewDidLoad() {
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getRealm()
        emptyCheck()
    }
    
    func getRealm() {
        
            let realm = try! Realm()
            let arriveTimeTables = realm.objects(TimeTable.self)
            favoliteList = [(name: String,direction:String,grade:String,date:Date,gradeInt:Int)]()
            for i in 0..<arriveTimeTables.count {
                let aTT = arriveTimeTables[i]
                let name:String = aTT.name
                let direction:String = aTT.direction
                let gradeArray:Array<String> = gradeIntToString(grade: aTT.grade)
                var grade = String()
                let date = aTT.date
                let gradeInt = aTT.grade
                for i in gradeArray {
                    grade += "[\(i)] "
                }
                favoliteList.append((name:name,direction:direction,grade:grade,date:date,gradeInt:gradeInt))
            }
        
      
       
    }
    
   
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return favoliteList.count
        
    }  
   
    
    //Mark: セルの編集ができるようにする。
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write {
                let n = favoliteList[indexPath.row].name
                let gInt = favoliteList[indexPath.row].gradeInt
                let d = favoliteList[indexPath.row].direction
                let obj = realm.objects(TimeTable.self).filter("name == \"\(n)\" && grade == \(gInt) && direction == \"\(d)\"")
                realm.delete(obj)
            }
            favoliteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        emptyCheck()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StationsTableViewCell
        cell.stationName.text = favoliteList[indexPath.row].name
        cell.direction.text = favoliteList[indexPath.row].direction
        cell.grade.text = favoliteList[indexPath.row].grade
        return cell
    }
    
    func emptyCheck(){
        if favoliteList.isEmpty{
            navigationItem.title = "　　  時刻表を追加しましょう   →"
        }else{
            navigationItem.title = "My List"
        }
    }
    //cellの高さ
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let data = favoliteList[indexPath.row]
                (segue.destination as! ShowViewController).data = data//destination = 行き先
            }
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    var gradeArray:Array /*0-13*/ = ["観光特急 青の交響曲",
                                     "観光特急しまかぜ（京都発着）",
                                     "観光特急しまかぜ（大阪難波発着）",
                                     "観光特急しまかぜ",
                                     "特急(運転日／行き先注意)",
                                     "特急(運転日／行き先注意)",
                                     "区間急行",
                                     "区間準急",
                                     "特急",
                                     "区間急行",
                                     "区間快速",
                                     "急行",
                                     "準急",
                                     "普通"
                                     ]
    func gradeIntToString(grade:Int)->Array<String>{
        var arr = [String]()
        var g:Decimal = Decimal(grade)
        var i:Int = 0
        while g != 0 {
            let n = 4096*2/pow(2,i)
            if n<=g{
                arr.append(gradeArray[gradeArray.count-i-1])
                g -= n
                i = 0
            }else{
                i += 1
            }
            
        }
        return arr
    }
    
    @IBAction func backToStations(segue: UIStoryboardSegue){
        print("backToHome")
        getRealm()
        tableView.reloadData()
        emptyCheck()
    }
}
