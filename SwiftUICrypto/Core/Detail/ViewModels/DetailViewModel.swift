//
//  DetailViewModel.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/20.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject{
    @Published var overviewStat: [StatisticModel] = []
    @Published var additionalStat: [StatisticModel] = []
    private let coinDetailService: CoinDetailService
    private var cancelable = Set<AnyCancellable>()
    
    @Published var coinDescription: String? = nil
    @Published var webUrl: String? = nil
    @Published var redditUrl: String? = nil
    
    @Published var coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailService(coin: coin)
        addSubcribe()
    }
    
    private func addSubcribe(){
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapData)
            .sink {[weak self] returnedArrays in
                self?.overviewStat = returnedArrays.overview
                self?.additionalStat = returnedArrays.additional
            }
            .store(in: &cancelable)
        
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetail in
                self?.coinDescription = returnedCoinDetail?.readableDescription
                self?.webUrl = returnedCoinDetail?.links?.homepage?.first
                self?.redditUrl = returnedCoinDetail?.links?.subredditURL
            }
            .store(in: &cancelable)
    }
    
    private func mapData(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        //overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketPercentCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketPercentCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return (overviewArray,additionalArray)
    }
}
