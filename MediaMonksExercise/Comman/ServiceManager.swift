//
//  ServiceManager.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 08/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import Foundation

//enum Result {
//    case Success
//    case Fail
//}

let albums_url = "https://jsonplaceholder.typicode.com/albums"

class ServiceManager {
    
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }

    static let shared = ServiceManager()
    private init() {}
    
    
    func fetchAlbumList(_ completionHandler: @escaping(Result<[Albums]>) -> Void) {
//        let finalStringUrl = albums_url.removingPercentEncoding
        guard let url: URL = URL(string: albums_url) else {
            completionHandler(Result.error(Error.unknownAPIResponse))
            return
        }
    
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(Result.error(error))
                }
                return
            }
            guard let _ = response, let data = data else {
                DispatchQueue.main.async {
                    completionHandler(Result.error(Error.unknownAPIResponse))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode([Albums].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(Result.results(model))
                }
            } catch let parsingError {
                DispatchQueue.main.async {
                   print("Error", parsingError)
                    completionHandler(Result.error(parsingError))
                }
            }
        }
        task.resume()
        
    }
}
