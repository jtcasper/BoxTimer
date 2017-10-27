//
//  BoxSettings.swift
//  BoxTimer
//
//  Created by Jacob Casper on 10/26/17.
//  Copyright © 2017 Jacob Casper. All rights reserved.
//

import UIKit
import os.log

class BoxSettings: NSObject, NSCoding {
    
    //MARK: Properties
    var roundMinutes: Int
    var breakMinutes: Int
    //TODO add round setting
    
    init(roundMinutes: Int, breakMinutes: Int) {
        self.roundMinutes = roundMinutes
        self.breakMinutes = breakMinutes
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("bsettings")
    
    //MARK: Types
    
    struct PropertyKey {
        static let roundMinutes = "roundMinutes"
        static let breakMinutes = "breakMinutes"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(roundMinutes, forKey: PropertyKey.roundMinutes)
        aCoder.encode(breakMinutes, forKey: PropertyKey.breakMinutes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let roundMinutes = aDecoder.decodeObject(forKey: PropertyKey.roundMinutes) as? Int else {
            os_log("Unable to decode the roundMinutes for a BoxSettings object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let breakMinutes = aDecoder.decodeObject(forKey: PropertyKey.breakMinutes) as? Int else {
            os_log("Unable to decode the breakMinutes for a BoxSettings object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(roundMinutes: roundMinutes, breakMinutes: breakMinutes)
    }

}
