//
//  ShowAlert.swift
//  ExchangeRateCalculator
//
//  Created by 정근호 on 4/19/25.
//

import UIKit

extension UIViewController {
    func showAlert(alertTitle: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        self.present(alert, animated: true)
    }
}
