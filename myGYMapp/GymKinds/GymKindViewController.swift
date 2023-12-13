//
//  gymKindViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class GymKindViewController: UIViewController {
    
    var viewmodel: GymKindViewModel!
    var finishVM: FinishViewModel!
    
    @IBOutlet var chestBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var legBtn: UIButton!
    @IBOutlet var shoulderBtn: UIButton!
    @IBOutlet var armBtn: UIButton!
    
    @IBOutlet var finishGym: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = GymKindViewModel()
        finishVM = FinishViewModel()
        configureView()
        viewmodel.loadData()
        viewmodel.observer()
        
    }
    
    @IBAction func tapQuestionMark(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "도움말",
                                      message: "1. 기록할 부위를 누르고 상세정보를 기입하세요. 2.모든 운동기록이 끝났으면 Finish 버튼을 클릭하세요 ", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인했습니다", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.saveData()
    }
    
    @IBAction func tapFinishBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "운동을 완료하시겠습니까?", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            
            guard let finishVC = self?.storyboard?.instantiateViewController(identifier: "FinishViewController") as? FinishViewController else {return}
            finishVC.viewmodel = self?.finishVM
            
            self!.finishVM.chestTotalvolume = self!.viewmodel.chestvolumevalue
            self!.finishVM.backTotalVolume = self!.viewmodel.backvolumevalue
            self!.finishVM.legTotalVolume = self!.viewmodel.legvolumevalue
            self!.finishVM.shoulderTotalVolume = self!.viewmodel.shouldervolumevalue
            self!.finishVM.armTotalVolume = self!.viewmodel.armvolumevalue
            
            self?.navigationController?.pushViewController(finishVC, animated: true)
        }
        let cancelBtn = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
    
    private func configureView() {
        chestBtn.layer.cornerRadius = 15
        backBtn.layer.cornerRadius = 15
        legBtn.layer.cornerRadius = 15
        shoulderBtn.layer.cornerRadius = 15
        armBtn.layer.cornerRadius = 15
        finishGym.layer.cornerRadius = 15
    }
    
}

