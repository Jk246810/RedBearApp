//
//  devicesViewController.swift
//  BLE Select
//
//  Created by Jamee Krzanich on 11/18/18.
//  Copyright © 2018 RedBear. All rights reserved.
//

import Foundation
import UIKit


protocol devicesViewControllerDelegate: NSObjectProtocol{
    // recipe == nil on cancel
//    print("here2")
    func didSelected(_ selected: Int)


}
class devicesViewController: UITableViewController{
    
    
    var selected: Int = 0
    
    var bleDevices: [Any] = []
    weak var delegate: devicesViewControllerDelegate?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bleDevices.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableIdentifier = "Cell"
        
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath)
        
        
        cell.textLabel?.text = bleDevices[indexPath.row] as? String
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        self.delegate?.didSelected(indexPath.row)
         print("HERE")
        navigationController?.popViewController(animated: true)
    }
}
