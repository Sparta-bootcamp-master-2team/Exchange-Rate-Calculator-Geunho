//
//  RatesCell.swift
//  CurrentRateCalculator
//
//  Created by 정근호 on 4/15/25.
//

import UIKit

final class ExchangeRateCell: UITableViewCell {
        
    static let id = "ExchangeRateCell"
    
    // MARK: - UI Components
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
        
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    private func setUI() {
        contentView.backgroundColor = .systemBackground
        
        [labelStackView, rateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {

        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.width.equalTo(120)
        }
    }
    
    // MARK: - Internal Methods
    /// Cell 정보 설정
    func configure(rateItem: RateItem) {
        currencyLabel.text = rateItem.currencyCode
        rateLabel.text = rateItem.value.toDigits(4)
        countryLabel.text = rateItem.countryName
    }
}
