//
//  ViewModelProtocol.swift
//  ExchangeRateCalculator
//
//  Created by 정근호 on 4/17/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var action: ((Action) -> Void)? { get }
    var state: State { get }
}

extension Double {
    // 소수점 자릿수 설정
    func toDigits(_ digit: Int) -> String {
        return String(format: "%.\(digit)f", self)
    }
}
