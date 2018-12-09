//
//  MoviesResponse.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

// 영화 정보 요청 결과를 얻기 위한 구조체
struct MoviesResponse: Codable {
    // 영화의 정렬 방법
    let orderType: Int
    // 실제 영화 정보
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case orderType = "order_type"
        case movies
    }
}
