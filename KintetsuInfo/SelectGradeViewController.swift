//
//  SelectGradeViewController.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/11/03.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit

class SelectGradeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var selectGradeTableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addButton: UIButton!
    
    var gradeArray:Array /*0-12*/ = ["観光特急 青の交響曲",
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
    ]
    var arr:Array = ["普通"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var g:Decimal = Decimal(grade!)
        var rows:Int = 1//普通
        var i:Int = 0
        while g != 0 {
            let n = 4096/pow(2,i)
            if n<=g{
                rows += 1
                g -= n
                i = 0
            }else{
                i += 1
            }
           
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! SelectGradeTableViewCell
        
      
        cell.grade.text = arr[indexPath.row]
        return cell
    }
    
    var grade:Int!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let navigation_title_text = UserDefaults.standard.string(forKey: "station"){
            navigationBar.topItem?.title = "\(String(describing: navigation_title_text))駅"
        }
        //AddButton
        
        addButton.layer.cornerRadius = 20
        addButton.layer.masksToBounds = false
        
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.5 // 透明度
        addButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
        addButton.layer.shadowRadius = 5 // ぼかし量
        addButton.layer.borderWidth = 1.0
        addButton.layer.borderColor = UIColor.orange.cgColor
        //複数選択
        selectGradeTableView.allowsMultipleSelection = true
        selectGradeTableView.delegate = self
        selectGradeTableView.dataSource = self
        grade = UserDefaults.standard.integer(forKey: "grade")
        // Do any additional setup after loading the view.
        //arrの設定
        var g:Decimal = Decimal(grade!)
        
        var i:Int = 0
        while g != 0 {
            let n = 4096/pow(2,i)
            if n<=g{
                arr.append(gradeArray[i])
                g -= n
                i = 0
            }else{
                i += 1
            }
            
        }
    }
    
    var selectedGrade:Decimal = 0
    //✓
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:SelectGradeTableViewCell = tableView.cellForRow(at: indexPath) as! SelectGradeTableViewCell
        if let gradeStr:String = cell.grade.text{
            if let index = gradeArray.firstIndex(of: gradeStr){
                selectedGrade += pow(2, index)
            }else if gradeStr == "普通"{
                selectedGrade += 8192
            }
        }
        cell.accessoryType = .checkmark
        print(selectedGrade)
        showAddButton()
    }
    //□
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:SelectGradeTableViewCell = tableView.cellForRow(at: indexPath) as! SelectGradeTableViewCell
        if let gradeStr:String = cell.grade.text{
            if let index = gradeArray.firstIndex(of: gradeStr){
                selectedGrade -= pow(2, index)
            }else if gradeStr == "普通"{
                selectedGrade -= 8192
            }
        }
        
        cell.accessoryType = .none
        print(selectedGrade)
        if selectedGrade == 0{
            dismissAddBUtton()
        }
    }
    
    func showAddButton(){
        if addButton.isHidden{
            addButton.isHidden.toggle()
            self.addButton.center.y += 300
        }
        if addButton.center.y > UIScreen.main.bounds.height{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
                self.addButton.center.y -= 300
            })
        }
        
    }
    func dismissAddBUtton(){
        if addButton.center.y < UIScreen.main.bounds.height{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
                self.addButton.center.y += 300
            })
        }
       
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissAddBUtton()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,willDecelerate decelerate: Bool){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.selectedGrade != 0{
                    self.showAddButton()
                }
            }
    
        
        
    }

  
   
    

    @IBAction func decide(_ sender: UIButton) {
        UserDefaults.standard.set(selectedGrade, forKey: "selectedGrade")
        if let myStoryboard = self.storyboard{
            let second = myStoryboard.instantiateViewController(withIdentifier: "get")
            self.present(second, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
