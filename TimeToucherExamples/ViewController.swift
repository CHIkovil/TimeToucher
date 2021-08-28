//
//  ViewController.swift
//  TimeToucherExamples
//
//  Created by Nikolas on 25.08.2021.
//

import UIKit
import TimeToucher

class ViewController: UIViewController {
    
    lazy var exampleView: TimeToucher = {
        let view = TimeToucher()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(exampleView)
        createConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        exampleView.animateArcs()
    }
    
    func createConstraints() {
        exampleView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exampleView.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        exampleView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 300).isActive = true
        exampleView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

