//
//  Validator.swift
//  365 - 24 - football
//
//  Created by Dmitry Gorbunow on 3/21/23.
//

import Foundation

import Foundation

class Validator {
    
    // method for verifying the correctness of the data entered by the user
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
