//
//  resultTableViewController.swift
//  HouseMeasure
//
//  Created by White on 2018/5/30.
//  Copyright © 2018年 White. All rights reserved.
//

import UIKit

class resultTableViewController: UITableViewController {

    var getResultDictionaries = [String:[Float]]()
    var getTitleSection = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        getTitleSection = [String](getResultDictionaries.keys)
        //print(getResultDictionaries)
        //print(getResultDictionaries.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return getTitleSection.count
        return getTitleSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let valuesKey = getTitleSection[section]
        guard let titleValues = getResultDictionaries[valuesKey] else {
            return 0
        }
        if valuesKey == "室內高度" {
            return titleValues.count // only one parameter.
        } else if valuesKey == "立體容積"{
            return titleValues.count/3 // * x * = result
        } else {
            return titleValues.count/2
        }
        
        //return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitleSection[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let valuesKey = getTitleSection[indexPath.section]
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        if valuesKey == "室內高度" {
            if let titleValues = getResultDictionaries[valuesKey] {
                cell.textLabel?.text = "\(indexPath.row+1). "+String(titleValues[indexPath.row])+"cm"
            }
        } else if valuesKey == "立體容積" {
            if let titleValues = getResultDictionaries[valuesKey] {
                let i = indexPath.row * 3
                cell.textLabel?.text = "\(indexPath.row+1). "+String(titleValues[i])+"cm x "+String(titleValues[i+1])+"cm x "+String(titleValues[i+2])+"cm = \(String(format: "%.4f",(titleValues[i]/100.0)*(titleValues[i+1]/100)*(titleValues[i+2]/100))) m³"
            }
        } else {
            if let titleValues = getResultDictionaries[valuesKey] {
                let i = indexPath.row * 2
                cell.textLabel?.text = "\(indexPath.row+1). "+String(titleValues[i])+"cm x "+String(titleValues[i+1])+"cm = \(String(format: "%.2f",(titleValues[i]/100.0)*(titleValues[i+1]/100))) m²"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valuesKey = getTitleSection[indexPath.section]
        if valuesKey == "牆壁面積" {
            let i = indexPath.row * 2
            let titleValues = getResultDictionaries[valuesKey]
            let result:Float = (titleValues![i]/100.0)*(titleValues![i+1]/100)*0.3025 //坪數
            //let usePaint:Float = result*0.03 //1坪需要 0.03加侖油漆
            let calculation = UIAlertController(title: "牆壁面積 油漆使用量", message: "此面積大約 \(String(format: "%.2f",result)) 坪，建議使用 \(String(format: "%.2f",result*0.03)) 加侖的油漆。\n 手刷建議使用 \(String(format: "%.2f",result*0.04)) 加侖的油漆", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
            calculation.addAction(cancelAction)
            
            present(calculation, animated: true, completion: nil) // show the alert
        }
    }
 


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}

// MARK: - User Actions
extension resultTableViewController {
    @IBAction func backToMainView(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "backToMainView", sender: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func debugBtn(_ sender: Any) {
        print(getResultDictionaries)
        print(getTitleSection.count)
        let calculation = UIAlertController(title: "小提示", message: "如果是牆壁面積，點選下去將會跳出油漆建議使用量！", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "我知道了!", style: .cancel, handler: nil)
        calculation.addAction(cancelAction)
        
        present(calculation, animated: true, completion: nil) // show the alert

    }
}
