//
//  BookingViewController.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/16/23.
//

import UIKit

class BookingViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bookingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupViews() {
        title = "Бронирование"
        
        nameTextField.setLeftPaddingPoints(16)
        phoneTextField.setLeftPaddingPoints(16)
        emailTextField.setLeftPaddingPoints(16)
        
        nameTextField.corneredRadius(radius: 10)
        phoneTextField.corneredRadius(radius: 10)
        emailTextField.corneredRadius(radius: 10)
        bookingButton.corneredRadius(radius: 14)
        bookingButton.setShadow()
    }

    @IBAction func bookingButtonAction(_ sender: Any) {

        guard !nameTextField.isEmpty && !phoneTextField.isEmpty && !emailTextField.isEmpty else {
            return self.showAlert(title: "Ошибка", message: "Заполните пустые поля" )
        }
        
        
        guard Validator.isValidEmail(for: emailTextField.text ?? "") else {
            return self.showAlert(title: "Ошибка", message: "Проверьте корректность ввода почты")
        }
        
        self.showAlert(title: "Бронирование", message: "Ваша заявка на бронирование принята")
    }
}



