
//
//  Photo.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 09/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import Foundation

class Photo: Codable {
    var albumId: Int = 0
    var id: Int = 0
    var title: String = ""
    var url: String = ""
    var thumbnailUrl: String = ""
    
    // download thumbnail image from url 
    func displayImage(_ urlString: String, completion: @escaping(Data) -> Void) {
        serviceManager.downlaodImage(urlString, completionHandler: { (result) in
            switch result {
            case .error(let error):
                print(error)
                completion(Data())
                break
            case .results(let result):
                serviceManager.thumbnailImage[urlString] = result
                completion(result)
                break
            }
        })
    }

}

