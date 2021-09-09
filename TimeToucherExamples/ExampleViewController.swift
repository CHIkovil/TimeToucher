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
        view.layer.cornerRadius = 200
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
        timerView.animateArcs()
    }
    
    func createConstraintsTimerView() {
        timerView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timerView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 400).isActive = true
        timerView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    func createConstraintsTimerLabel() {
        timerLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: timerView.topAnchor, constant: -5).isActive = true
        timerLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 300).isActive = true
        timerLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension ExampleViewController: TimeToucherDelegate{
    func timeMoved(formatTime: String) {
//        UIView.animate(withDuration: 0.1){[weak self] in
//            guard let self = self else{return}
//            
//            let animation = CABasicAnimation(keyPath: "position")
//            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.timerLabel.center.x, y: self.timerLabel.center.y + 20))
//            animation.toValue = NSValue(cgPoint: CGPoint(x: self.timerLabel.center.x, y: self.timerLabel.center.y))
//
//            self.timerLabel.layer.add(animation, forKey: "position")
//            self.timerLabel.text = formatTime
//        }
        self.timerLabel.text = formatTime
    }
}
