//
//  ViewController.swift
//  BoxTimer
//
//  Created by Jacob Casper on 10/13/17.
//  Copyright © 2017 Jacob Casper. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var minutes = 0
    var seconds = 2
    var running = false
    var timer: Timer!
    
    let dateFormatter = DateFormatter()
//    let soundPath =
    let bellSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bell", ofType: "mp3")!)
    var bellPlayer = AVAudioPlayer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "mm:ss"
        do {
            try self.bellPlayer = AVAudioPlayer(contentsOf: self.bellSound)
            self.bellPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func startPause(_ sender: UIButton) {
        if !running {
            // Timer is paused or stopped
            startButton.setTitle("Pause", for: UIControlState.normal)
            running = true
            let timerDate = dateFormatter.date(from: "\(minutes):\(seconds)")
            countdownTimer.text = dateFormatter.string(from: timerDate!)
            countdownTimer.alpha = 1.0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.decrementTime), userInfo: nil, repeats: true)
        } else {
            // Timer is running; pause it
            startButton.setTitle("Start the Clock", for: UIControlState.normal)
            running = false
            timer.invalidate()
        }
    }
    
    //MARK: Private Functions
    @objc private func decrementTime() {
        if seconds == 0 && minutes == 0 {
            bellPlayer.play()
            startButton.backgroundColor = UIColor.red
        } else if seconds == 0 {
            minutes -= 1
            seconds = 59
        } else {
            seconds -= 1
        }
        let timerDate = dateFormatter.date(from: "\(minutes):\(seconds)")
        countdownTimer.text = dateFormatter.string(from: timerDate!)
    }
    


}

