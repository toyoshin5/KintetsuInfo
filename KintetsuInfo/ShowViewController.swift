//
//  ShowViewController.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/12/22.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit
import RealmSwift
class ShowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var showTableView: UITableView!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var directionScrollView: CBAutoScrollLabel!
    @IBOutlet weak var todayNotFoundView: UIView!
    
    var isAll = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        tableView.rowHeight = UITableView.automaticDimension
        return times_after.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! ShowTableViewCell
        let t = times_after[indexPath.row]
        let str = "\(NSString(format: "%02d",t.time.hour)):\(NSString(format: "%02d",t.time.minute))\n "
        cell.time.text = str
        cell.grade.text = gradeZeroIntToString(grade: t.grade)
        cell.grade.layer.cornerRadius = 3
        cell.grade.adjustsFontSizeToFitWidth = true
        cell.grade.clipsToBounds = true
        cell.grade.textColor = UIColor.white
        cell.grade.backgroundColor = gradeZeroIntToColor(grade: t.grade)
        cell.remain.text = setRemainingTime(t: t.time)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = tableView.frame.size.height
        return isAll ? 100 : h/(h>550 ? 4 : 3)
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.showTableView.center.x -= self.view.bounds.width
            
        },completion: { _ in
            self.showTableView.reloadData()
        })
  
        
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            
            self.showTableView.center.x += self.view.bounds.width
        })
        
        showTableView.isScrollEnabled.toggle()
        isAll.toggle()
        self.showTableView.setContentOffset(CGPoint(x: 0, y: -self.showTableView.contentInset.top), animated: false)
        
        
    }
    
    var data:(name: String,direction:String,grade:String,date:Date,gradeInt:Int)!
    var times = [T_Time]()
    var times_after = [T_Time]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showTableView.delegate = self
        showTableView.dataSource = self
        
        
        let realm = try! Realm()
        try! realm.write {
            let n = data.name
            let gInt = data.gradeInt
            let d = data.direction
            let aTT:TimeTable = realm.objects(TimeTable.self).filter("name == \"\(n)\" && grade == \(gInt) && direction == \"\(d)\"").first!
            if isHoliday(){
                for t:Int in aTT.timeSerial_H {times.append(T_Time(serial: t))}
            }else{
                for t:Int in aTT.timeSerial {times.append(T_Time(serial: t))}
            }
            
            //今以降のみ
            deleteBeforeNow()
           
    
            stationLabel.text = n
            stationLabel.clipsToBounds = true
            stationLabel.layer.cornerRadius = 10
            directionScrollView.text = d// 表示するテキスト
            directionScrollView.textColor = UIColor.white;            directionScrollView.labelSpacing = 50;                          // 開始と終了の間間隔
            directionScrollView.pauseInterval = 1;                          // スクロール前の一時停止時間
            directionScrollView.scrollSpeed = 50.0;                         // スクロール速度
            directionScrollView.fadeLength = 10.0;                          // 左端と右端のフェードの長さ
            directionScrollView.font = UIFont.systemFont(ofSize: 25.0)      // フォント設定
            
            showTableView.isScrollEnabled = false
        }

        let myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(loop), userInfo: nil,repeats: true)
        RunLoop.current.add(myTimer, forMode: RunLoop.Mode.common)
        
        //todayNotFoundView
        todayNotFoundView.frame.size = CGSize(width: 300, height: 50)
        todayNotFoundView.center = view.center
        
        
        if times_after.isEmpty{
            todayNotFoundView.isHidden = false
            todayNotFoundView.layer.cornerRadius = 10
            todayNotFoundView.layer.masksToBounds = false
            todayNotFoundView.layer.borderColor = UIColor.black.cgColor
            todayNotFoundView.layer.borderWidth = 1.0
            let message = "本日の運行は終了しました"
            let label = UILabel()
            label.text = message
            label.center.x = 0
            label.textAlignment = NSTextAlignment.center
            label.frame.size = CGSize(width: 300, height: 50)
            todayNotFoundView.addSubview(label)
            
        }else{
            todayNotFoundView.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    func isHoliday() -> Bool {
        let comp = Calendar.Component.weekday
        let weekday = NSCalendar.current.component(comp, from: NSDate() as Date)
        if weekday == 1 || weekday == 7 {
            return true
        }
        return false
    }
    
    func deleteBeforeNow(){
        var new_times_after = [T_Time]()
        for t_time in times{
            let remainingTime:Time = setRemainingTime(t: t_time.time)
            if remainingTime.hour >= 0 &&  remainingTime.minute >= 0 &&  remainingTime.second >= 0 {
                new_times_after.append(t_time)
            }
        }
        if new_times_after.count != times_after.count{
            showTableView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.showTableView.alpha = 1
            })
        }
        times_after = new_times_after
    }
    
    @objc func loop(){
        deleteBeforeNow()
        if !isAll{
            let vCell = showTableView.visibleCells as! [ShowTableViewCell]
            for cell in vCell{
                cell
            }
            
        }
    }
 
    func gradeZeroIntToColor(grade:Int)->UIColor{
        switch grade{
        case 0:
            return UIColor.black
        case 1:
            return UIColor.green
        case 2:
            return UIColor.orange
        case 4:
            return UIColor(red: 1, green: 0.25, blue: 0, alpha: 0)
        case 8:
            return UIColor.red
        case 16:
            return UIColor.red
        case 32:
            return UIColor.green
        case 64:
            return UIColor(red: 1, green: 0.25, blue: 0, alpha: 0)
        case 128:
            return UIColor.red
        case 256:
            return UIColor.blue
        case 512:
            return UIColor.blue
        case 1024:
            return UIColor.blue
        case 2048:
            return UIColor.blue
        case 4096:
            return UIColor.blue
            
        default:
            break
        }
        return UIColor.black
    }
    func gradeZeroIntToString(grade:Int)->String{
        switch grade{
        case 0:
            return "普通"
        case 1:
            return "準急"
        case 2:
            return "急行"
        case 4:
            return "区快"
        case 8:
            return "快急"
        case 16:
            return "特急"
        case 32:
            return "区準"
        case 64:
            return "区急"
        case 128:
            return "特急"
        case 256:
            return "しまかぜ"
        case 512:
            return "しまかぜ"
        case 1024:
            return "しまかぜ"
        case 2048:
            return "しまかぜ"
        case 4096:
            return "青の交響曲"
        
        default:
            break
        }
        return "種別取得失敗"
    }
    func setRemainingTime(t:Time)->Time{
        let sa:Time = t-t.nowTime()
        return sa
        
    }
    func setRemainingTime(t:Time)->String{
        let sa:Time = t-t.nowTime()
        var h = "°" ,m = "'" ,s = "\""
        h = (sa.hour == 0) ? "" : String(sa.hour)+h
        m = (sa.minute == 0) ? "" : String(sa.minute)+m
        s = String(sa.second)+s
        return "\(h)\(m)\(s)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
