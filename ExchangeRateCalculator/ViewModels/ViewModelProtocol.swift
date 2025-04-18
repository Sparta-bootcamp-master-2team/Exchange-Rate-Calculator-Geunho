//
//  ViewModelProtocol.swift
//  ExchangeRateCalculator
//
//  Created by 정근호 on 4/17/25.
//

import Foundation

enum ExchangeRateState {
    case idle
    case loaded([RateItem])
    case error
}

enum ExchangeRateAction {
    /// 초기에 불러올 경우
    case fetch
    /// 검색값에 의해 필터링 된 경우
    case filter(String)
}

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var action: ((Action) -> Void)? { get }
    var state: State { get }
}

extension Double {
    /// 소수점 자릿수 설정
    func toDigits(_ digit: Int) -> String {
        return String(format: "%.\(digit)f", self)
    }
}
