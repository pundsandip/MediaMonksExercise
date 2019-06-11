//
//  Result.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 08/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import Foundation

import Foundation

enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
