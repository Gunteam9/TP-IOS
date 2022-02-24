//
//  ViewController.swift
//  TestP1
//
//  Created by tplocal on 21/01/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var timerLabel: UILabel!
    private var timer: Timer = Timer();
    private var timing = 0;
    private var isRunning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    private func onTimerUpdate() {
        if (isRunning) {
            timing += 1;
            print(timing);
            let minutes: Int = ((timing / 100) % 100) / 60 ;
            let secondes: Int = (timing / 100) % 100;
            let milli: Int = timing % 100;
            timerLabel.text = "\(minutes) : \(secondes) : \(milli)";
        }

    }
    
    @IBAction func onStartPressed(_ sender: Any) {
        timer.invalidate();

        isRunning = true;
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(onTimerUpdate), userInfo: nil, repeats: true);
    }
    
    @IBAction func OnStopPressed(_ sender: Any) {
        timing = 0;
        isRunning = false;
        timer.invalidate();
    }
    
    @IBAction func OnResetPressed(_ sender: Any) {
        timing = 0;
        isRunning = false;
        timer.invalidate();
        timerLabel.text = "00:00:00";
    }
    
    
    
}

