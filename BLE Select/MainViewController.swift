//
//  MainViewController.swift
//  BLE Select
//
//  Created by Jamee Krzanich on 11/18/18.
//  Copyright © 2018 RedBear. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BLEDelegate, devicesViewControllerDelegate {
    let ble = BLE();
    var previousConnection = false;
    var lastUUID : NSString? = "";
    let UUIDPrefKey = ("UUIDPrefKey") as NSString;
    var devices : NSMutableArray = [];
    
    
    
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ble.controlSetup()
        ble.delegate = self
        
        if (lastUUID!.length > 0)
        {
            self.uuidLabel.text = self.lastUUID as String?;
        }
        else
        {
            self.lastButton.isHidden = true;
        }
        //Need to set up buttons and labels
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LastClick(_ sender: Any) {
        ble.findPeripherals(3)
        Timer.scheduledTimer(timeInterval: TimeInterval(Float(3.0)), target: self, selector: #selector(self.connectionTimer(_:)), userInfo: nil, repeats: false)
        previousConnection = true
        self.lastButton.isHidden = true;
        self.scanButton.isHidden = true;
    }
    
    @IBAction func scanClick(_ sender: Any) {
        if((ble.activePeripheral) != nil) {
            if(ble.activePeripheral.state == CBPeripheralState.connected) {
                ble.cm.cancelPeripheralConnection(ble.activePeripheral)
                return
            }
        }
        if((ble.peripherals) != nil) {
            ble.peripherals = nil
        }
        ble.findPeripherals(3)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(Float(3.0)), target: self, selector: #selector(self.connectionTimer(_:)), userInfo: nil, repeats: false)
        previousConnection = false
        self.lastButton.isHidden = true
        self.scanButton.isHidden = true
        
    }
    
    
    
    func connectionTimer(_ timer: Timer?) {
        if(ble.peripherals != nil && ble.peripherals.count > 0){
            if(previousConnection) {
              
                for i in 0..<ble.peripherals.count {
                    let p = ble.peripherals[i] as? CBPeripheral
                    if(p?.identifier.uuidString != nil) {
                        if (lastUUID?.isEqual(to: p!.identifier.uuidString))! {
                            ble.connectPeripheral(p)
                        }
                    }
                }
            }
            else {
                devices.removeAllObjects()
                for j in 0..<ble.peripherals.count {
                    let p = ble.peripherals[j] as? CBPeripheral
                    if(p?.identifier.uuidString != nil) {
                        devices.insert(p?.identifier.uuidString as Any, at: j)
                    }else {
                        devices.insert("NULL", at: j)
                    }
                }
                self.performSegue(withIdentifier: "showDevice", sender: self)
            }
        }
        
        
        else {
            if (self.lastUUID?.length == 0) {
                self.lastButton.isHidden = true;
            }else{
                self.lastButton.isHidden = false;
            }
            self.scanButton.isHidden = false;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDevice") {
            let vc = segue.destination as? devicesViewController
           
            vc?.bleDevices = devices as! [Any]
            vc?.delegate = self as? devicesViewControllerDelegate
        }
    }
    
    func didSelected(_ index: Int) {

        //check this funtion when testing
        
        scanButton.isHidden = true
        
        ble.connectPeripheral(ble.peripherals.object(at: index) as! CBPeripheral)
    }
    func bleDidDisconnect() {
        self.lastButton.isHidden = false;
        self.rssiLabel.isHidden = true;
        scanButton.setTitle("Scan All", for: .normal)
        
    }
    func bleDidReceiveData(_ data: UnsafeMutablePointer<UInt8>!, length: Int32) {
    }
    func bleDidConnect() {
        print("in here")
        lastUUID = ble.activePeripheral.identifier.uuidString as NSString
        UserDefaults.standard.set(lastUUID, forKey: UUIDPrefKey as String)
        UserDefaults.standard.synchronize()
        print("origional")
        print(uuidLabel.text)
        lastButton.isHidden = true
        scanButton.isHidden = false
        uuidLabel.text = lastUUID! as String
        rssiLabel.text = "RSSI: ?"
        rssiLabel.isHidden = false
        scanButton.setTitle("Disconnect", for: .normal)
        print("connected")
        print(uuidLabel.text)
    }
    
    func bleDidUpdateRSSI(_ rssi: NSNumber?) {
        rssiLabel.text = "RSSI: \("\(rssi)")"
    }
    
    func getUUIDString(_ ref: CFUUID?) -> String? {
        var str: String? = nil
        if let aRef = ref {
            str = "\(aRef)"
        }
        return ("\(str ?? "")" as NSString).substring(with: NSRange(location: (str?.count ?? 0) - 36, length: 36))
    }
   

}

