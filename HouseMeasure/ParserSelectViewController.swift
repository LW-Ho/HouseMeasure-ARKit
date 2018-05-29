//
//  ParserSelectViewController.swift
//  HouseMeasure
//
//  Created by White on 2018/5/25.
//  Copyright © 2018年 White. All rights reserved.
//

import UIKit

class ParserSelectViewController: UIViewController {
    
    @IBOutlet weak var measureOption: UIPickerView!
    @IBOutlet weak var calculateBtn: UIButton!
    
    let measureObject = ["牆壁面積","地板坪數","室內高度","窗戶大小","門框大小"]
    var sendString:String?

    var calculationDictionaries: Dictionary = [String: [Float]] ()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEnv() // initialization
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Users Actions

extension ParserSelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return measureObject.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return measureObject[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        sendString = measureObject[row] // set the String to sender.
        
    }
    
    
    func setUpEnv() {
        measureOption.dataSource = self
        measureOption.delegate = self
        calculateBtn.isHidden = true //還未開始所以不能計算
    }

    @IBAction func startBtn(_ sender: UIButton) {
        
//        self.present(arVC, animated: true, completion: nil)
//        self.textDelegate = arVC
//        self.textDelegate?.fetchString(sendString ?? "Error")
        
        self.performSegue(withIdentifier: "SelectTitle", sender: nil)
        
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if sendString != nil {
//                if let sendTitleToNextView = segue.destination as? ViewController {//Main view ARViewController
//                    sendTitleToNextView.getTitleString = sendString
//
//                }
//            }
//        }
        
    }

    
    @IBAction func calculatingBtn(_ sender: UIButton) {
        if !calculationDictionaries.isEmpty {
            calculateBtn.isHidden = false
            
        }
    }
}

// MARK: Segue Pass Values

extension ParserSelectViewController {
    func updateView() {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectTitle" {
            let arVC = segue.destination as! ViewController
            arVC.getTitleString = sendString ?? "Error String"
        }
    }

}
