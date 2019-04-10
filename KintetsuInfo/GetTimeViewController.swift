//
//  getTimeViewController.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/12/11.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit
import Ji
import WebKit
import RealmSwift
import KRProgressHUD
class GetTimeViewController: UIViewController,WKNavigationDelegate {
    
    
    @IBOutlet weak var successButton: UIButton!
    @IBOutlet weak var succeedLabel: UILabel!
    @IBOutlet weak var succeedLabel2: UILabel!
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
                                     "普通",
                                     ]
    //toGetUrl
    //selectedGrade
    //toGetDirection
    var webView = WKWebView()
    var webView_H = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.set(style: .custom(background: UIColor.orange, text: UIColor.white, icon: UIColor.white))
        KRProgressHUD.set(activityIndicatorViewColors:([UIColor.white, UIColor.white]))
        KRProgressHUD.set(viewOffset: UIScreen.main.bounds.height/2-200)
        KRProgressHUD.show()
        if isiPhoneXScreen(){
             successButton.layer.cornerRadius = 39
        }
       
        succeedLabel.alpha = 0
        succeedLabel2.alpha = 0
        
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: rect, configuration: webConfiguration)
        webView_H = WKWebView(frame: rect, configuration: webConfiguration)
        
        if let url = UserDefaults.standard.url(forKey: "toGetUrl"){
            let urlReq = URLRequest(url: url)
            webView.load(urlReq)
            view.addSubview(webView)
        }else{
            print("無効なURLでした")
        }
        if let url_H = UserDefaults.standard.url(forKey: "toGetUrl_H"){
            let urlReq = URLRequest(url: url_H)
            webView_H.load(urlReq)
            view.addSubview(webView_H)
        }else{
            print("無効なURLでした")
        }
        
        webView.navigationDelegate = self
        webView_H.navigationDelegate = self//オブジェクトを作ってからデリゲートを通す
        // Do any additional setup after loading the view.
    }
    var loadCount = 0
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       loadCount+=1
        if loadCount >= 2{
            loaded()
        }
    }
    
    
    func isiPhoneXScreen() -> Bool {
        return UIScreen.main.bounds.height/UIScreen.main.bounds.width>2.0
    }
    
    func loaded(){
         let arriveTimeTable = TimeTable()
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (html:Any?, error:Error?) -> Void in
            if let JiDoc = Ji(htmlString: html as! String, encoding: .utf8){
                let arriveTime = self.getArriveTime(JiDoc: JiDoc)
                let arrivrTimeSerial = self.t_timeToSerial(arriveTime: arriveTime)
                let name = UserDefaults.standard.string(forKey: "station")
                let direction = UserDefaults.standard.string(forKey: "toGetDirection")
                let grade = UserDefaults.standard.integer(forKey: "selectedGrade")
                arriveTimeTable.set(name: name!, direction: direction! ,grade:grade ,timeSerial: arrivrTimeSerial,date: Date())
                self.webView_H.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (html:Any?, error:Error?) -> Void in
                    if let JiDoc = Ji(htmlString: html as! String, encoding: .utf8){
                        let arriveTime = self.getArriveTime(JiDoc: JiDoc)
                        let arrivrTimeSerial = self.t_timeToSerial(arriveTime: arriveTime)
                        arriveTimeTable.set(timeSerial_H: arrivrTimeSerial)
                        
                        self.saveRealm(timeTable: arriveTimeTable)
                        
                    }
                })
            }
        })
       
    }
    func notOverlapCheck(timeTable TT:TimeTable,realm:Realm)->Bool{
        for aTT in realm.objects(TimeTable.self){
            if TT.direction == aTT.direction && TT.grade == aTT.grade && TT.name == aTT.name{
                return false
            }
        }
        return true
    }
    
    func saveRealm(timeTable:TimeTable){
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            if notOverlapCheck(timeTable: timeTable, realm: realm){
                try! realm.write {
                    realm.add(timeTable)
                    print(timeTable)
                    showButtonFromBottom()
                }
            }else{
                succeedLabel.text = "Error: 既に追加されています"
                succeedLabel.font = succeedLabel.font.withSize(20)
            showButtonFromBottom()
            successButton.backgroundColor = UIColor.lightGray
            
            }
        } catch {
            print("でDBに書き込みできませんでした")
            showButtonFromBottom()
            successButton.setTitle("Failed...", for: .normal)
        }
    }
    
    func showButtonFromBottom(){
        KRProgressHUD.set(viewOffset: 10000)
        KRProgressHUD.set(duration: 0)
        KRProgressHUD.show()
        KRProgressHUD.dismiss()
        successButton.center.y = UIScreen.main.bounds.height-200
        successButton.layer.cornerRadius = 10
        successButton.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.successButton.center.y = UIScreen.main.bounds.height/2
            self.successButton.layer.cornerRadius = self.successButton.layer.bounds.height/2
        },completion:{ _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
                self.successButton.layer.cornerRadius = 0
                self.successButton.layer.bounds = UIScreen.main.bounds
                self.succeedLabel.alpha = 1
            },completion:{ _ in
                UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
                     self.succeedLabel2.alpha = 1
                })
            })
        })
        
    }
    
    func t_timeToSerial(arriveTime: Array<T_Time>) -> Array<Int>{
        var arrivrTimeSerial = Array<Int>()
        for t:Int in 0..<arriveTime.count{
            arrivrTimeSerial.append(arriveTime[t].getSerial())
        }
        return arrivrTimeSerial
    }
    /*
     
     trNode1:: <tr>
     tdNode1:: <td align="center" width="40" bgcolor="#C6FBB1"><b>11</b></td>
                    <td width="663">
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tbody>
     trNode2::                 <tr>
     tdNode2::                      <td align="center" nowrap class="jikoku">
                                            <a href="T7?sf=4240&amp;tx=1-323&amp;dw=0&amp;date=20181212&amp;time=1100">
                                                        <div class="K_1906">名<br>
     minuteNode::                                                <div class="min">09</div>
     
     */
    func getArriveTime(JiDoc:Ji )->Array<T_Time>{
        var timeTable = Array<T_Time>()
        let node = JiDoc.xPath("/html/body/div//table[1]/tbody//tr[4]/td/table/tbody/tr/td/table/tbody/tr/td/table/tbody")?.first
        let endNode = JiDoc.xPath("/html/body/div//table[1]/tbody//tr[4]/td/table/tbody/tr/td/table/tbody/tr/td/table/tbody" + "/tr[@bgcolor='#FFFFFF']")?.first
        for tr:Int in 1...20 {//if[2] 5:00
            let trNode1 = node?.children[tr]
            if trNode1 == endNode{break}
            let tdNode1 = trNode1?.children[0]
            var hour:Int = Int((tdNode1!.children[0].content!))!
            let trNode2 = trNode1?.children[1].children[0].children[0].children[0]
            for tdNode2 in trNode2!.children {
                if isItGrade(node: tdNode2.children[0].children[0]){
                    let minuteNode = tdNode2.children[0].children[0].childrenWithAttributeName("class", attributeValue: "min").first
                    //しまかぜのxxC表現対応
                    let mixedString = minuteNode!.content!//"25c等"
                    let splitNumbers = (mixedString.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
                    let number = splitNumbers.joined()
                    let minute:Int = Int(number)!
                    let grade:Int = getGrade(node: tdNode2)
                    //00:xx
                    if hour == 0{
                        hour = 24
                    }
                    let time = T_Time(hour: hour, minute: minute, second: 0, grade: grade)
                    timeTable.append(time)
                }else{
                }
                
            }
            
            
        }
        return timeTable
        
    }
    
    
}
func isItGrade(node:JiNode)->Bool{
    let c = node["class"]
    let n:Int = UserDefaults.standard.integer(forKey: "selectedGrade")
    switch c{
    case "K_1901":
        return (n%16384 >= 8192)
    case "K_1902":
        return (n%8192 >= 4096)
    case "K_1903":
        return (n%4096 >= 2048)
    case "K_1904":
        return (n%2048 >= 1024)
    case "K_1905":
        return (n%1024 >= 512)
    case "K_1906":
        return (n%512 >= 256)
    case "K_1907":
        return (n%256 >= 128)
    case "K_1908":
        return (n%128 >= 64)
    case "K_1909":
        return (n%64 >= 32)
    case "K_1910":
        return (n%32 >= 16)
    case "K_1911":
        return (n%16 >= 8)
    case "K_1912":
        return (n%8 >= 4)
    case "K_1913":
        return (n%4 >= 2)
    case "K_1914":
        return (n%2 >= 1 )
    default:
        break;
    }
    return false
}


func getGrade(node:JiNode) -> Int{
    let gradeNode = node.children[0].children[0]
    if let cls = gradeNode["class"]{
        switch cls{
        case "K_1901":
            return 0;
        case "K_1902":
            return 1;
        case "K_1903":
            return 2;
        case "K_1904":
            return 4;
        case "K_1905":
            return 8;
        case "K_1906":
            return 16;
        case "K_1907":
            return 32;
        case "K_1908":
            return 64;
        case "K_1909":
            return 128;
        case "K_1910":
            return 256;
        case "K_1911":
            return 512;
        case "K_1912":
            return 1024;
        case "K_1913":
            return 2048;
        case "K_1914":
            return 4096;
        default:
            break;
        }
        return 0;
    }
    return 0;
    
}

class TimeTable:Object{
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var direction = ""
    @objc dynamic var grade = 0
    @objc dynamic var date = Date()
    let timeSerial = List<Int>()
    let timeSerial_H = List<Int>()
    func set(name n:String,direction d:String,grade g:Int,timeSerial t:Array<Int>, date: Date){
        self.name = n
        self.direction = d
        self.grade = g
        self.date = date
        for i in 0..<t.count {
            self.timeSerial.append(t[i])
        }
    }
    func set(timeSerial_H t:Array<Int>){
        for i in 0..<t.count {
            self.timeSerial_H.append(t[i])
        }
    }
    

}


class  T_Time{
    var time = Time()
    var grade:Int
    init(serial:Int){
        grade = serial/100000
        let second = serial%100000
        time.hour = second/3600
        time.minute = (second%3600)/60
        time.second = second%60
        
    }
    init(hour h:Int,minute m:Int,second s:Int,grade g:Int){
        time.second = s
        time.minute = m
        time.hour = h
        grade = g
    }
    
    func getSerial() -> Int {
        let serial = time.hour*3600+time.minute*60+time.second+grade*100000
        return serial;
        //ggggssssss
    }
    
}

class Time{
    var second:Int
    var minute:Int
    var hour:Int
    init(){
        second = 0
        minute = 0
        hour = 0
    }
    init(hour h:Int,minute m:Int,second s:Int){
        second = s
        minute = m
        hour = h
        let extraMin = second/60
        let extraHour = minute/60
        minute += extraMin
        hour += extraHour
        second -= 60 * extraMin
        minute -= 60 * extraHour
    }
    func nowTime()->Time{
        
        let now = Date() // 現在日時の取得
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP") // ロケールの設定
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        var strArray:Array = dateFormatter.string(from: now).components(separatedBy: "/")[2].components(separatedBy: " ")[1].components(separatedBy: ":")
        // ->　["10", "32", "22"]
        let nowTime = Time()
        nowTime.hour = Int(strArray[0])!
        nowTime.minute = Int(strArray[1])!
        nowTime.second = Int(strArray[2])!
        return nowTime
    }
    static func - (left: Time, right: Time) -> Time {
        let end = left.hour*3600 + left.minute*60 + left.second
        let start = right.hour*3600 + right.minute*60 + right.second
        let during = end - start

        let dTime:Time = Time(hour: during/3600, minute: (during%3600)/60, second: during%60)
        return dTime
    }
    static func + (left: Time, right: Time) -> Time {
        let start = left.hour*3600 + left.minute*60 + left.second
        let end = right.hour*3600 + right.minute*60 + right.second
        let during = end + start
        let dTime:Time = Time(hour: during/3600, minute: (during%3600)/60, second: during%60)
        return dTime
    }
    
}
