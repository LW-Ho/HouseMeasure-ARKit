//
//  ViewController.swift
//  HouseMeasure
//
//  Created by White on 2018/5/23.
//  Copyright © 2018年 White. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneARView: ARSCNView!
    @IBOutlet weak var stateString: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var meterBtn: UIButton!
    
    
    fileprivate lazy var session = ARSession()
    fileprivate lazy var sessionConfiguration = ARWorldTrackingConfiguration()
    fileprivate lazy var isMeasuring = false;
    fileprivate lazy var isHave2Lines = true;
    fileprivate lazy var vectorZero = SCNVector3()
    fileprivate lazy var startValue = SCNVector3()
    fileprivate lazy var endValue = SCNVector3()
    fileprivate lazy var lines: [Line] = []
    fileprivate var currentLine: Line?
    fileprivate lazy var unit: DistanceUnit = .centimeter
    fileprivate lazy var all2Lines:[Float] = []
    
    var getTitleString:String = "" //接收主頁面傳送的主題字串

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        stateString.text = getTitleString //塞入
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneARView.session.pause()
        session.pause()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetValues()
        isMeasuring = true
        targetImageView.image = UIImage(named: "targetGreen")

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMeasuring = false
        targetImageView.image = UIImage(named: "targetWhite")
        if let line = currentLine {
            
            lines.append(line)
            currentLine = nil
            cleanBtn.isHidden = false

        }
    }
}

// MARK: - ARSCNViewDelegate

// for debug
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            self?.detectObjects()
        }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        messageLabel.text = "Error occurred"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        messageLabel.text = "Interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        messageLabel.text = "Interruption ended"
    }
}

// MARK: - Users Actions

extension ViewController{

    func removeAllLines() {
        cleanBtn.isHidden = true
        for line in lines {
            line.removeFromParentNode()
        }
        lines.removeAll()
    }
    
    @IBAction func backtoMain(_ sender: Any) {
        let lineCounts = lines.count
        if lineCounts % 2 == 0 || stateString.text == "室內高度" {
            performSegue(withIdentifier: "backFromARView", sender: nil)
        } else {
            let alertVC = UIAlertController(title: "Warning", message: "Please draw two lines, not one.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Okay!", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func meterButtonTapped(button: UIButton) {
        let alertVC = UIAlertController(title: "Settings", message: "Please select distance unit options", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: DistanceUnit.centimeter.title, style: .default) { [weak self] _ in
            self?.unit = .centimeter
        })
//        alertVC.addAction(UIAlertAction(title: DistanceUnit.inch.title, style: .default) { [weak self] _ in
//            self?.unit = .inch
//        })
//        alertVC.addAction(UIAlertAction(title: DistanceUnit.meter.title, style: .default) { [weak self] _ in
//            self?.unit = .meter
//        })
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func cleanLineBtn(button: UIButton) {
        if !lines.isEmpty {
            let counts = lines.count
            lines[counts-1].removeFromParentNode()
            lines.removeLast()
            NSLog("number of lines: \(counts) \n remove lase line.")
        }
    }
    
    func processString() -> [Float] {
        if !lines.isEmpty {
            all2Lines = []
            for line in lines {
                let endString = line.getTextString().index(of: "c") ?? line.getTextString().endIndex
                let fixString = line.getTextString()[..<endString]
                let currentLength = Float(fixString) ?? 0
                
                all2Lines.append(currentLength)
                //return currentLength
            }
        }
        return all2Lines
    }
    
    
    
}

// MARKL - AR Kit working

extension ViewController {
    fileprivate func setupScene() {
        targetImageView.isHidden = true
        sceneARView.delegate = self
        sceneARView.session = session
        loadingView.startAnimating()
        messageLabel.text = "Detecting the World..."
        cleanBtn.isHidden = true
        session.run(sessionConfiguration, options: [.resetTracking, .removeExistingAnchors])
        resetValues()
    }
    
    fileprivate func resetValues() {
        isMeasuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
    }
    
    fileprivate func detectObjects() {
        guard let worldPosition = sceneARView.realWorldVector(screenPosition: view.center) else  {
            return
        }
        targetImageView.isHidden = false
        if lines.isEmpty {
            messageLabel.text = "Hold the Screen And \n Move Your  "+UIDevice.modelName+" ..."
        }
        loadingView.stopAnimating()
        
        if isMeasuring {
            if startValue == vectorZero {
                startValue = worldPosition
                currentLine = Line(sceneView: sceneARView, startVector: startValue, unit: unit)
            }
            endValue = worldPosition
            currentLine?.update(to: endValue)
            messageLabel.text = currentLine?.distance(to: endValue) ?? "Calculating..."
        }
        
        //print(currentLine?.lineLegth(to: endValue) ?? "Error Value...")
    }
}



