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

        return titleValues.count
        //return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitleSection[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let valuesKey = getTitleSection[indexPath.section]
        if let titleValues = getResultDictionaries[valuesKey] {
            cell.textLabel?.text = String(titleValues[indexPath.row])
        }

        return cell
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
    }
}
