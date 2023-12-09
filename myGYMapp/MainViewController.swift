//
//  ViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var historyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 15
        historyBtn.layer.cornerRadius = 15
    }
    
    @IBAction func tapStartBtn(_ sender: UIButton) {
    }
    
    @IBAction func tapHistoryBtn(_ sender: UIButton) {
    }
    
}

