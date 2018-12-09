//
//  Comment.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

struct Comment: Codable {
    // 영화 고유 ID
    let movieId: String
    // 작성자
    let writer: String
    // 한줄평 내용
    let contents: String
    // 작성일시
    let timestamp: Double
    // 평점
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case rating
        case timestamp
        case writer
        case movieId = "movie_id"
        case contents
    }
}
