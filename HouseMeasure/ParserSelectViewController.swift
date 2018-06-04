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
    @IBOutlet weak var calculationBtn: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    
    
    
    let measureObject = ["立體容積","牆壁面積","地板坪數","室內高度","窗戶大小","門框大小"]
    var sendString:String?

    var calculationDictionaries = [String: [Float]] () //Dictionaries
    var getString:String = ""
    var getArray:[Float] = []
    
    let emptyView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpEnv() // initialization
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goToResult(_ sender: UIButton) {
        print(calculationDictionaries)
        //let resultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultTableViewID")
        //self.navigationController?.pushViewController(resultVC, animated: true)

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
    
//    func pickerView(_ pickerView: UIPickerView,
//                    didSelectRow row: Int,
//                    inComponent component: Int) {
//        sendString = measureObject[row] // set the String to sender.
//    }
    
    
    func setUpEnv() {
        measureOption.dataSource = self
        measureOption.delegate = self
        calculationBtn.isHidden = true //還未開始所以不能計算
        setUpPopView()
        
    }
    
    func setUpPopView() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        singleTapGesture.delegate = self as? UIGestureRecognizerDelegate
        mainImage?.addGestureRecognizer(singleTapGesture)
        
        let subviewTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeView))
        subviewTapGesture.delegate = self as? UIGestureRecognizerDelegate
        emptyView.addGestureRecognizer(subviewTapGesture)
    }
    
    @objc func didTapImage() {
        print("Can tap.")
        emptyView.backgroundColor = .gray
        //emptyView.frame = self.view.frame
        let viewPoint = CGPoint(x: 0.1 * self.view.frame.width, y: 0.1 * self.view.frame.height)
        let viewSize = CGSize(width: 300, height: 500)//CGSize(width: 0.75 * self.view.frame.width, height: 0.75 * self.view.frame.height)
        emptyView.frame = CGRect(origin: viewPoint, size: viewSize)
        
        
        // add information using UILabel()
        let informationLabel = UILabel(frame: CGRect(x:0.1 * emptyView.frame.width,y: 0.1 * emptyView.frame.height, width:emptyView.frame.width, height:400))
        informationLabel.numberOfLines = 0
        informationLabel.text = "參與人員\n\n北科大資工所 - 何鎮宇\n北科大資工所 - 李炘潤\n致理科大多媒體系 - 林佩儒"
        informationLabel.center = CGPoint(x: emptyView.frame.width/2, y: 0.15 * emptyView.frame.height)
        informationLabel.textAlignment = .center
        
        emptyView.addSubview(informationLabel)
        self.view.addSubview(emptyView)
        
    }
    
   @objc func removeView() {
        emptyView.removeFromSuperview()
    }

//    @IBAction func startBtn(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "SelectTitle", sender: nil)
//    }
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        let touchPoint = touch.location(in: emptyView)
//        // 如果touchPoint在播放列表的视图范围内，则不响应手势
//        if emptyView.frame.contains(touchPoint) {
//            return false
//        } else {
//            return true
//        }
//    }

    

}

// MARK: Segue Pass and Back Values

extension ParserSelectViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToARView" {
            let arVC = segue.destination as! ViewController
            let optionIndex = measureOption.selectedRow(inComponent: 0)
            let optionString = measureObject[optionIndex]
            sendString = optionString
            arVC.getTitleString = sendString ?? "Error Type"
        }
        if segue.identifier == "goToTableView" {
            let tableVC = segue.destination as! resultTableViewController
            tableVC.getResultDictionaries = calculationDictionaries
        }
    }
    
    @IBAction func backSegue(segue: UIStoryboardSegue) {
        if segue.identifier == "backFromARView" {
            let backVC = segue.source as! ViewController
            calculationBtn.isHidden = false
            getArray = backVC.processString()
            backVC.removeAllLines()
            
            calculationDictionaries[sendString!] = getArray //使用Dict 儲存
        }
        
        if segue.identifier == "backToMainView" {
            self.navigationController?.isNavigationBarHidden = true
        }
    }

}
