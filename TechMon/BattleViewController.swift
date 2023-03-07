//
//  BattleViewController.swift
//  TechMon
//
//  Created by Owner on 2023/02/16.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    @IBOutlet var playerTPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var playerHP: Int = 100
    var playerTP: Int = 0
    var enemyHP: Int = 400
    var enemyMP: Int = 0
    
    var gameTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //プレイヤーの設定を反映
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")

        //敵の設定を反映
        enemyNameLabel.text = "ドラゴン"
        enemyImageView.image = UIImage(named: "monster.png")
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(updateGame),
            userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    //0.1秒ごとにゲームの状態を更新する
    @objc func updateGame() {
        //敵のステータスを更新
        enemyMP += 1
        
        if enemyMP >= 35 {
            enemyAttack()
            enemyMP = 0
        }
        
        //プレイヤーのステータスを反映
        playerHPLabel.text = "\(playerHP) / 100"
        playerTPLabel.text = "\(playerTP) / 100"
        
        //敵のステータスを反映
        enemyHPLabel.text = "\(enemyHP) / 400"
        enemyMPLabel.text = "\(enemyMP) / 35"
        
        judgeBattle()
    }
    
    //敵の攻撃
    func enemyAttack() {
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        //敵がダメージを与える
        playerHP -= 20
    }
    
    //勝敗が決定した時の処理
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else {
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
        }
        
        let alert = UIAlertController(
            title: "バトル終了",
            message: finishMessage,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @IBAction func attackAction() {
        techMonManager.damageAnimation(imageView: enemyImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        //こうげきでダメージを与える
        enemyHP -= 20
        
        playerTP += 5
        if playerTP >= 80 {
            playerTP = 80
        }
    }
    
    @IBAction func chargeAction() {
        techMonManager.playSE(fileName: "SE_charge")
        
        playerTP += 10
        if playerTP >= 80 {
            playerTP = 80
        }
    }
    
    @IBAction func fireAction() {
        if playerTP >= 40 {
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            //ファイアでダメージを与える
            enemyHP -= 40
            
            playerTP -= 40
            if playerTP <= 0 {
                playerTP = 0
            }
        }
    }
    
    //勝敗の判定
    func judgeBattle() {
        if playerHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        } else if enemyHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
}
