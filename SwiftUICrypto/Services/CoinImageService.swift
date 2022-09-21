import Foundation
import UIKit
import Combine

class CoinImageService{
    @Published var image: UIImage? = nil
    private let coin: CoinModel
    private var imageSubscription: AnyCancellable?
    private let fileManager = LocalFileManager.instance
    private var imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(name: imageName){
            image = savedImage
//            print("Received from FileManager")
        }else{
            downloadCoinImage()
            print("Received from Download")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription =  NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadImage = returnedImage else { return }
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(key: self.imageName, value: downloadImage )
            })
    }
}
