//
//  SelectLineViewController.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/10/23.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit
import Ji
import WebKit
import KRProgressHUD

class SelectLineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate {
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var selectLineTableView: UITableView!
    var selectLineList = [(name:String,direction:String,url:String,url_H:String)]()//≒lineLinkData

    func getArray()-> [(name:String,direction:String,url:String,url_H:String)]{
    var lineLinkData = [(name:String,direction:String,url:String,url_H:String)]()
        if let array = UserDefaults.standard.array(forKey: "name"){
            let nameArray:[String] = UserDefaults.standard.array(forKey: "name") as! [String]
            let directionArray:[String] = UserDefaults.standard.array(forKey: "direction")as! [String]
            let urlArray:[String] = UserDefaults.standard.array(forKey: "url")as! [String]
            let url_HArray:[String] = UserDefaults.standard.array(forKey: "url_H")as! [String]
            for i in 0..<array.count{
                
            lineLinkData.append((name:nameArray[i],direction:directionArray[i],url:urlArray[i],url_H:url_HArray[i]))
            }
           
        }
        return lineLinkData
        
    }
    //cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectLineList.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! SelectLineTableViewCell
        cell.name.text = selectLineList[indexPath.row].name
        cell.direction.text = selectLineList[indexPath.row].direction
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.set(style: .custom(background: UIColor.orange, text: UIColor.white, icon: UIColor.white))
        KRProgressHUD.set(activityIndicatorViewColors:([UIColor.white, UIColor.white]))
        KRProgressHUD.set(viewOffset: 0)
        selectLineTableView.delegate = self
        selectLineTableView.dataSource = self
        if let navigation_title_text = UserDefaults.standard.string(forKey: "station"){
            naviTitle.title = "\(String(describing: navigation_title_text))駅"
        }
        print("loaded")
        let lineLinkdata:[(name:String,direction:String,url:String,url_H:String)] = getArray()
        for i in 0..<lineLinkdata.count {
            selectLineList.append((name: lineLinkdata[i].name,direction: lineLinkdata[i].direction,url: lineLinkdata[i].url,url_H: lineLinkdata[i].url_H))
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
      
    }
    
    // MARK: - Table view data source
    
  
    var webView = WKWebView()
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
  
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        KRProgressHUD.show(withMessage:"Loading..." )
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: rect, configuration: webConfiguration)
        //gradeを調べるだけなので平日のみで良い
        if let url = URL(string: selectLineList[indexPath.row].url){
            if let url_H = URL(string: selectLineList[indexPath.row].url_H){
                UserDefaults.standard.set(url, forKey: "toGetUrl")//getViewで使う
                UserDefaults.standard.set(url_H, forKey: "toGetUrl_H")//getViewで使う
                let urlReq = URLRequest(url: url)
                webView.load(urlReq)
                view.addSubview(webView)
            }else{
                print("無効なURLでした_H")
            }
           
        }else{
            print("無効なURLでした")
        }
    
        let direction = selectLineList[indexPath.row].direction
        UserDefaults.standard.set(direction, forKey: "toGetDirection")
        
         webView.navigationDelegate = self//オブジェクトを作ってからデリゲートを通す
    }
 
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (html:Any?, error:Error?) -> Void in
            if let JiDoc = Ji(htmlString: html as! String, encoding: .utf8){
                let grade:Int = self.getStationGrade(JiDoc: JiDoc)

                UserDefaults.standard.set(grade, forKey: "grade")
                if let myStoryboard = self.storyboard{
                    let second = myStoryboard.instantiateViewController(withIdentifier: "grade")
                    KRProgressHUD.dismiss()
                    self.present(second, animated: true, completion: nil)
                }
                
            }
        })
      
        
    }
/*
     1901,近鉄,,,,,普通,#000000
     1902,近鉄,,,,,準急,#009900
     1903,近鉄,,,,,急行,#5f3dff
     1904,近鉄,,,,,区間快速,#FF0000
     1905,近鉄,,,,,快速急行,#FF0000
     1906,近鉄,,,,,特急,#FF0000
     ----------------------------------
     1907,近鉄,,,,,区間準急,#009900        追加分
     1908,近鉄,,,,,区間急行,#5f3dff
     1909,近鉄,,,,,特急:運転日／行き先注意,#60BF00
     1910,近鉄,,,,,観光特急しまかぜ,#B4F0FF
     1911,近鉄,,,,,観光特急しまかぜ（大阪難波発着）,#B4F0FF
     1912,近鉄,,,,,観光特急しまかぜ（近鉄名古屋発着）,#B4F0FF
     1913,近鉄,,,,,観光特急しまかぜ（京都発着）,#B4F0FF
     1914,近鉄,,,,,観光特急 青の交響曲（シンフォニー）,#7DBEFF

 */
    func getStationGrade(JiDoc:Ji) -> Int{
        var grade:Int = 0
        for i in 0...10 {
            let node = JiDoc.xPath("//*[@class='remarks']//div[\(i)]")
            if (node?.first?["class"]) != nil{
                    let className:String = node?.first?["class"] ?? "K_1901"
                    switch className{
                    case "K_1902":
                        grade += 1
                    case "K_1903":
                        grade += 2
                    case "K_1904":
                        grade += 4
                    case "K_1905":
                        grade += 8
                    case "K_1906":
                        grade += 16
                    case "K_1907":
                        grade += 32
                    case "K_1908":
                        grade += 64
                    case "K_1909":
                        grade += 128
                    case "K_1910":
                        grade += 256
                    case "K_1911":
                        grade += 512
                    case "K_1912":
                        grade += 1024
                    case "K_1913":
                        grade += 2048
                    case "K_1914":
                        grade += 4096
                    default:
                        break;
                    }

            }
        }
        
        return grade
    }
 
    @IBAction func backToSelectLine(segue: UIStoryboardSegue){
        print("backToHome")
    }
}

