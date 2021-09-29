//
//  ViewController.swift
//  TimeToucherExamples
//
//  Created by Nikolas on 25.08.2021.
//

import UIKit
import TimeToucher

class ExampleViewController: UIViewController {
    
    lazy var timerView: TimeToucher = {
        let view = TimeToucher()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1).cgColor
        view.layer.cornerRadius = self.view.frame.width / 2
        view.layer.masksToBounds = true
        view.alpha = 0.85
        view.backgroundColor = #colorLiteral(red: 0.978312552, green: 0.9784759879, blue: 0.9782910943, alpha: 1)
        
        view.delegate = self
        
        return view
    }()
    
    lazy var timerLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00:00"
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.font = .systemFont(ofSize: 60, weight: UIFont.Weight.bold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(timerView)
        view.addSubview(timerLabel)
        
        createConstraintsTimerView()
        createConstraintsTimerLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        timerView.animateArcs(setup: setup())
    }
    
    public func setup() -> ASTimeToucher {
        let mainViewWidth = view.frame.width
        let secondLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 0.05 * mainViewWidth, radius: 0.075 * mainViewWidth, startDegree: 0, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1), animationDuration: 6, animationLineSetup: secondLine)
        
        let minuteLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 0.075 * mainViewWidth, radius: 0.15 * mainViewWidth, startDegree: 70, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 4, animationLineSetup: minuteLine)
        
        let hourLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 0.1 * mainViewWidth, radius: 0.25 * mainViewWidth, startDegree: 180, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 2, animationLineSetup: hourLine)
        
        return ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
    }
    
    func createConstraintsTimerView() {
        timerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timerView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        timerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    func createConstraintsTimerLabel() {
        timerLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: timerView.topAnchor, constant: -5).isActive = true
        timerLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 300).isActive = true
        timerLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension ExampleViewController: TimeToucherDelegate{
    func timeMoved(timeToSeconds: Int) {
        let timeFormat: [String] = secondsToHoursMinutesSeconds(seconds: timeToSeconds).map {val in
            if val < 10{
                return "0\(val)"
            }else{
                return "\(val)"
            }
        }
        self.timerLabel.text = timeFormat.joined(separator: ":")
    }

}

extension ExampleViewController {
    func secondsToHoursMinutesSeconds (seconds : Int) -> [Int] {
      return [seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60]
    }
}
