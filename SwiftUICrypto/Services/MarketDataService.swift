import Foundation
import Combine

class MarketDataService{
    @Published var marketData: MarketDataModel? = nil
    var cancelable : AnyCancellable?
    let dataUrl = "https://api.coingecko.com/api/v3/global"
    
    init(){
        getData()
    }
    
    func getData(){
        guard let url = URL(string: dataUrl) else { return }
        
        cancelable =  NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedData in
                self?.marketData = returnedData.data
                self?.cancelable?.cancel()
            })
    }
}
