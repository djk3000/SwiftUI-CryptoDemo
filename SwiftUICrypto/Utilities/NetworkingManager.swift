//
//  NetworkingManager.swift
//  SwiftUICrypto
//
//  Created by 邓璟琨 on 2022/9/9.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkError: LocalizedError{
        case badURLResponse(url : URL)
        case unknown
        
        var errorDescription: String?{
            switch self {
            case .badURLResponse(url: let url):
                return "Bad responde from URL.\(url)"
            case .unknown:
                return "Unknow error occured."
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error>{
       return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else{
            throw NetworkError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break;
        case .failure(let error):
            print("Error download data. \(error)")
        }
    }
}
