//
//  DatePresenter.swift
//  rdshell
//
//  Created by Derik Ramirez on 9/30/19.
//

import Foundation

class PromptTimer {
    
    let customMode = "com.rderik.myevents"
    
    func start() {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode(customMode))
    }
    
    @objc func printTime(timer: Timer) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let currentDateTime = Date()
        let strTime = formatter.string(from: currentDateTime)
        print("\u{1B}7\r[\(strTime)] $ \u{1B}8", terminator: "")
        fflush(__stdoutp)
    }
}
