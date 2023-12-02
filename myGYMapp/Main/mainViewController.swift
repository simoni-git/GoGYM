//
//  ViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class mainViewController: UIViewController {
    
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var historyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 15
        historyBtn.layer.cornerRadius = 15
    }
    
    @IBAction func tapStartBtn(_ sender: UIButton) {
        // 나중에 운동시작버튼을 누르면 시간이 가기 시작하게끔 업데이트해보자.
    }
    
    @IBAction func tapHistoryBtn(_ sender: UIButton) {
    }
    
}

