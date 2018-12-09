//
//  Movie.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

struct Movie: Codable {
    // 영화 고유 ID
    let id: String
    // 영화제목
    let title: String
    // 관람등급
    let grade: Int
    // 개봉일
    let date: String
    // 포스터 이미지 섬네일 주소
    let thumb: String
    // 예매순위
    let reservationGrade: Int
    // 예매율
    let reservationRate: Double
    // 사용자 평점
    let userRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case grade
        case date
        case thumb
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
