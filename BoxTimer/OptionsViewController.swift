//
//  OptionsViewController.swift
//  BoxTimer
//
//  Created by Jacob Casper on 10/26/17.
//  Copyright © 2017 Jacob Casper. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var roundMinutePickerView: UIPickerView!
    
    let minutePickerDataSource = ["2", "3", "4", "5"]
    
    var roundMinuteSetting: Int?
    var settings: BoxSettings?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundMinutePickerView.dataSource = self
        self.roundMinutePickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : UIPickerViewDelegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  minutePickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minutePickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roundMinuteSetting = Int(minutePickerDataSource[row])
    }
    
    
    

    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
            settings = BoxSettings(roundMinutes: roundMinuteSetting ?? Int(minutePickerDataSource[0])!, breakMinutes: 1)
    }

}
