//
//  ViewController.swift
//  BoxTimer
//
//  Created by Jacob Casper on 10/13/17.
//  Copyright © 2017 Jacob Casper. All rights reserved.
//

import UIKit
import os.log
import AVFoundation


class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var settings: BoxSettings!
    let settingsSeconds = 0
    var running = false
    var roundMinutes: Int = 0
    var breakMinutes: Int = 0
    var seconds: Int = 0
    var timer: Timer!
    
    let dateFormatter = DateFormatter()
    let bellSound = URL(fileURLWithPath: Bundle.main.path(forResource: "bell", ofType: "mp3")!)
    var bellPlayer = AVAudioPlayer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Attempt to get settings
        if let savedSettings = loadSettings() {
            print("sxsload")
            settings = savedSettings
        } else {
            settings = BoxSettings(roundMinutes: 3, breakMinutes: 1)
        }
        dateFormatter.dateFormat = "mm:ss"
        roundMinutes = settings.roundMinutes
        breakMinutes = settings.breakMinutes
        seconds = settingsSeconds
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
            let timerDate = dateFormatter.date(from: "\(roundMinutes):\(seconds)")
            countdownTimerLabel.text = dateFormatter.string(from: timerDate!)
            countdownTimerLabel.alpha = 1.0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.decrementTime), userInfo: nil, repeats: true)
        } else {
            // Timer is running; pause it
            startButton.setTitle("Start the Clock", for: UIControlState.normal)
            running = false
            timer.invalidate()
        }
    }
    
    @IBAction func stopClock(_ sender: UIButton) {
        self.stop()
    }
    
    
    
    @IBAction func unwindToTimer(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? OptionsViewController, let settings = sourceViewController.settings {
            self.settings = settings
            // Stop the clock and reload with new settings
            stop()
            
            // Save the settings.
            saveSettings()
        }
    }
    

    

    
    //MARK: Private Functions
    @objc private func decrementTime() {
        if seconds == 0 && roundMinutes == 0 {
            bellPlayer.play()
            startButton.backgroundColor = UIColor.red
        } else if seconds == 0 {
            roundMinutes -= 1
            seconds = 59
        } else {
            seconds -= 1
        }
        setTimerLabel()
    }
    
    // Handles stopping the countdown
    private func stop() {
        running = false
        roundMinutes = settings.roundMinutes
        breakMinutes = settings.breakMinutes
        seconds = settingsSeconds
        startButton.setTitle("Start the Clock", for: UIControlState.normal)
        self.setTimerLabel()
        if (timer != nil) {
            timer.invalidate()
        }
    }
    
    private func setTimerLabel() {
        let timerDate = dateFormatter.date(from: "\(roundMinutes):\(seconds)")
        countdownTimerLabel.text = dateFormatter.string(from: timerDate!)
    }
    
    private func saveSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.settings, toFile: BoxSettings.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Settings successfully saved.", log: OSLog.default, type: .debug)
            loadSettings()
        } else {
            os_log("Failed to save settings...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSettings() -> BoxSettings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: BoxSettings.ArchiveURL.path) as? BoxSettings
    }
    


}

