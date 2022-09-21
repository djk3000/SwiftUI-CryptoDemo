import Foundation
import Combine

class CoinDetailService{
    @Published var coinDetails: CoinDetailModel? = nil
    var cancelable : AnyCancellable?
    let coin: CoinModel
    init(coin: CoinModel){
        self.coin = coin
        getCoinsDetail()
    }
    
    func getCoinsDetail(){
        let coinUrl = "https://api.coingecko.com/api/v3/coins/\(coin.id)?tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        
        guard let url = URL(string: coinUrl) else { return }
        
        cancelable =  NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedModel in
                self?.coinDetails = returnedModel
                self?.cancelable?.cancel()
            })
    }
}
