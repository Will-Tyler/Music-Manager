//
//  ViewController.swift
//  Music Manager
//
//  Created by Will Tyler on 7/15/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

	private let welcomeLabel: UILabel = {
		let label = UILabel()

		label.text = "Hello"
		label.textAlignment = .center

		return label
	}()

	private func setupInitialLayout() {
		view.addSubview(welcomeLabel)

		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.heightAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.height).isActive = true
		welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = .white

		setupInitialLayout()
	}

}

