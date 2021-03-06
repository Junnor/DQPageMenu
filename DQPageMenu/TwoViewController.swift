//
//  TwoViewController.swift
//  DQPageMenu
//
//  Created by nyato喵特 on 2017/7/20.
//  Copyright © 2017年 nyato喵特. All rights reserved.
//

import UIKit

class TwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.rowHeight = 70
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 22
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath)
        cell.textLabel?.text = "Two \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self), didSelectRowAt: \(indexPath)")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
