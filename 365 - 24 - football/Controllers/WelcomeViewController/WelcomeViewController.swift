//
//  OnboardingViewController.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/9/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var continueButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        continueButton.corneredRadius(radius: 14)
    }
    

    // MARK: - IBActions
    @IBAction func continueButtonAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "MapViewController", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "Map")
        navigationController?.setViewControllers([vc], animated: true)
    }
}
