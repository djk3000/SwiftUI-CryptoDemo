//
//  HomeViewModel.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/9.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins : [CoinModel] = []
    @Published var protfolioCoins : [CoinModel] = []
    
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinService = CoinDataService()
    private let marketService = MarketDataService()
    private let portfolioService = PorfolioDataService()
    private var cancelable = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
        addSubcribers()
    }
    
    func addSubcribers(){
        //update coins
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest(coinService.$allCoins, $sortOption)
            .map(filterAndSortCoins)
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelable)
        
        //update portfolioCoins
        $allCoins
            .combineLatest(portfolioService.$savedEntities)
            .map(makeAllCoinsToPortfolioCoins)
            .sink {[weak self] returnedCoins in
                guard let self = self else { return }
                self.protfolioCoins = self.sortPortfolioCoins(coins: returnedCoins)
            }
            .store(in: &cancelable)
        
        //update market data
        marketService.$marketData
            .combineLatest($protfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStat in
                self?.statistics = returnedStat
                self?.isLoading = false
            }
            .store(in: &cancelable)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinService.getCoins()
        marketService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort{ $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort{ $0.rank > $1.rank }
        case .price:
            coins.sort{ $0.currentPrice < $1.currentPrice }
        case .priceReversed:
            coins.sort{ $0.currentPrice > $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoins(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        let lowerText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowerText) ||
            coin.symbol.lowercased().contains(lowerText) ||
            coin.id.lowercased().contains(lowerText)
        }
    }
    
    private func makeAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stat: [StatisticModel] = []
        guard let data = data else { return stat }
        
        let marketCap = StatisticModel(title: "Market cup", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volumn = StatisticModel(title: "24h Volumn", value: data.volume)
        let btcDomiance = StatisticModel(title: "BTC Domiance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }
            .reduce(0, +)
        let previousValue = protfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue ) / previousValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stat.append(contentsOf: [
            marketCap,
            volumn,
            btcDomiance,
            portfolio
        ])
        
        return stat
    }
}
