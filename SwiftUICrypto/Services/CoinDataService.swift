//
//  CoinDataServices.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/9.
//

import Foundation
import Combine

class CoinDataService{
    @Published var allCoins: [CoinModel] = []
    var cancelable : AnyCancellable?
    let coinUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true"
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: coinUrl) else { return }
        
        cancelable =  NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedModel in
                self?.allCoins = returnedModel
                self?.cancelable?.cancel()
            })
    }
}
