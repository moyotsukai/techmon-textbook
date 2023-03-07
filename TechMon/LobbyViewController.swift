//
//  LobbyViewController.swift
//  TechMon
//
//  Created by Owner on 2023/02/16.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    
    let techMonManager = TechMonManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //ロビー画面が見えるようになる時に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    //ロビー画面が見えなくなる時に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
}
