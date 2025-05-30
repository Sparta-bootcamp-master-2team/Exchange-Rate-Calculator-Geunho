//
//  MainViewController.swift
//  CurrentRateCalculator
//
//  Created by 정근호 on 4/15/25.
//

import UIKit
import SnapKit
import Combine

final class ExchangeRateViewController: UIViewController {
    
    let viewModel = ExchangeRateViewModel()
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "통화 검색"
        bar.searchBarStyle = .minimal
        bar.delegate = self
        bar.autocapitalizationType = .none
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        // 테이블 뷰에다가 테이블 뷰 셀 등록
        tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.id)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var emptyTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "검색 결과 없음"
        label.textColor = UIColor(named: AppColor.secondaryTextColor)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("메인뷰로드")
        
        setUI()
        setLayout()
        bindViewModel()
        viewModel.setExchangeRate(.fetch)
        setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LastScreenDataManager.shared.saveLastScreen(name: "ExchangeRateView")
    }
    
    // MARK: - UI & Layout
    private func setUI() {
        view.backgroundColor = UIColor(named: AppColor.backgroundColor)
        self.title = "환율 정보"
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        [searchBar, tableView, emptyTextLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Action
    /// 키보드 해제
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        
        // 상태에 따라 emptyTextLabel 표시, Alert 표시 등 동작
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle:
                    break
                case .loaded(let items):
                    // 검색 결과 없을 시 "검색 결과 없음" 표시
                    self.emptyTextLabel.isHidden = !items.isEmpty
                    self.tableView.reloadData()
                case .error:
                    self.showAlert(alertTitle: "오류", message: "데이터를 불러올 수 없습니다", actionTitle: "확인")
                }
            }.store(in: &cancellables)
    }
    
    
    /// TapGesture 추가, tapGesture.cancelsTouchesInView = false로 뷰 내 터치 정상적으로 동작
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}


// MARK: - UITableView
extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 셀렉션 효과(터치 자국) 제거 
        tableView.deselectRow(at: indexPath, animated: true)

        // CalculatorView, CalculatorViewModel 생성
        let calculatorViewModel = CalculatorViewModel(rateItem: viewModel.rateItems[indexPath.row])
        
        let calculatorView = CalculatorViewController(viewModel: calculatorViewModel)
        
        self.navigationController?.pushViewController(calculatorView, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rateItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.rateItems[indexPath.row]
        let cellViewModel = ExchangeRateCellViewModel(rateItem: item)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else {
            return UITableViewCell()
        }
        cell.bindViewModel(cellViewModel)
        
        // 클릭 이벤트 받음(구독), 즐겨찾기 업데이트
        cellViewModel.favoriteTogglePublisher
            .sink { [weak self] (currencyCode, isFavorite) in
                self?.viewModel.updateFavorite(currencyCode: currencyCode, isFavorite: isFavorite)
            }
            .store(in: &cancellables)
        
        return cell
    }
}

// MARK: - UISearchBar
extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        viewModel.setExchangeRate(.filter(text))
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
