//
//  ExchangeRateCellViewModel.swift
//  ExchangeRateCalculator
//
//  Created by 정근호 on 4/21/25.
//

import Foundation
import Combine

class ExchangeRateCellViewModel {
    
    private let favoritesData = FavoritesDataManager()
    @Published var rateItem: RateItem
    @Published var isFavorite: Bool
    
    // 버튼 클릭 이벤트
    let favoriteTogglePublisher = PassthroughSubject<(String, Bool), Never>()
    
    init(rateItem: RateItem) {
        self.rateItem = rateItem
        self.isFavorite = rateItem.isFavorite
    }
    
    /// 즐겨찾기 상태 설정
    func setFavoriteStatus() {
        rateItem.isFavorite.toggle()
        self.isFavorite = rateItem.isFavorite
        if rateItem.isFavorite {
            favoritesData.createData(currencyCode: rateItem.currencyCode)
        } else {
            favoritesData.deleteData(selectedCode: rateItem.currencyCode)
        }
        // 클릭 이벤트 send (ExchangeRateViewController: UITableViewDataSource에서 받음)
        favoriteTogglePublisher.send((rateItem.currencyCode, rateItem.isFavorite))
    }
}
