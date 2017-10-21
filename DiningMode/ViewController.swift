//
//  ViewController.swift
//  DiningMode
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

import AFNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //show a modal VC
        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitleColor(view.backgroundColor, for: .normal)
        button.layer.cornerRadius = 4.0
        button.setTitle("launch a modal", for: .normal)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 60.0),
            button.widthAnchor.constraint(equalToConstant: 160.0),
            ])
        button.addTarget(self, action: #selector(launchDemoModal(_:)), for: .touchUpInside)
    }

    @objc func launchDemoModal(_ sender: UIButton) {
        let modalVC = UIViewController()
        modalVC.view.frame = UIScreen.main.bounds;
        modalVC.view.backgroundColor = .green

        let dismissButton = UIButton(type: .custom)
        modalVC.view.addSubview(dismissButton)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.backgroundColor = .blue
        dismissButton.layer.cornerRadius = 4.0
        dismissButton.setTitle("dismiss", for: .normal)
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: modalVC.view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: modalVC.view.centerYAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 60.0),
            dismissButton.widthAnchor.constraint(equalToConstant: 160.0),
            ])
        dismissButton.addTarget(self, action: #selector(self.dismissThis(_:)), for: .touchUpInside)

        self.present(modalVC, animated: true, completion: nil)
    }

    @objc func dismissThis(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

