//
//  SecondViewController.swift
//  PageScroll
//
//  Created by Ju on 2017/7/5.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        cell.textLabel?.text = "Second \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self), didSelectRowAt: \(indexPath)")
        self.tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "whiteV", sender: nil)
    }

}
