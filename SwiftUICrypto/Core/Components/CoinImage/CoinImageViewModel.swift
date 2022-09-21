//
//  CoinImageViewModel.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/9.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var cancelable = Set<AnyCancellable>()
    
    private let coin: CoinModel
    
    private let dataService: CoinImageService
    
    init(coin: CoinModel){
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubcribers()
    }
    
    private func addSubcribers(){
        dataService.$image
            .sink {[weak self] _ in
                self?.isLoading = false
            } receiveValue: {[weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancelable)
    }
}
