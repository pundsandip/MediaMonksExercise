//
//  ServiceManager.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 08/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import Foundation


let albums_url = "https://jsonplaceholder.typicode.com/albums"
let photos_url = "https://jsonplaceholder.typicode.com/photos"
let serviceManager = ServiceManager.shared

class ServiceManager {
    
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }

    var thumbnailImage: [String: Data] = [:]
    var fullImage: [String: Data] = [:]
    static let shared = ServiceManager()
    private init() {}
    
    
    func fetchAlbumList(_ completionHandler: @escaping(Result<[Album]>) -> Void) {
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
                let model = try decoder.decode([Album].self, from: data)
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
    
    func fetchPhotosList(_ completionHandler: @escaping(Result<[Photo]>) -> Void) {
        guard let url: URL = URL(string: photos_url) else {
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
                let model = try decoder.decode([Photo].self, from: data)
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
    
    // download image from given url 
    func downlaodImage(_ urlString: String, completionHandler: @escaping(Result<Data>) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                
                DispatchQueue.main.async {
                    completionHandler(Result.results(data))
                }
            }
            task.resume()
        }
    }
    
}
