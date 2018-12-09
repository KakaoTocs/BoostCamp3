//
//  MovieInfo.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

struct MovieInfo: Codable {
    // 영화 고유 ID
    let id: String
    // 영화제목
    let title: String
    // 개봉일
    let date: String
    // 총 관람객수
    let audience: Int
    // 배우진
    let actor: String
    // 영화 상영 길이
    let duration: Int
    // 감독
    let director: String
    // 줄거리
    let synopsis: String
    // 영화 장르
    let genre: String
    // 관람등급
    let grade: Int
    // 포스터 이미지 주소
    let image: String
    // 예매순위
    let reservationGrade: Int
    // 예매율
    let reservationRate: Double
    // 사용자 평점
    let userRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case audience
        case actor
        case duration
        case director
        case synopsis
        case genre
        case grade
        case image
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
    
    static func requestMovieInfo(by id: String) {
        // API요청 URL
        guard let url: URL = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=" + id) else {
            return
        }
        // 세션 생성
        let session: URLSession = URLSession(configuration: .default)
        // API에 요청해 처리하는 Task생성 및 요청
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // 에러 발생시 출력
            if let error = error {
                print(error.localizedDescription)
//                NotificationCenter.default.post(name: self.movieInfoRequestErrorNotificationKey, object: nil)
                return
            }
            
            // API요청후 얻은 결과값이 nil인지 확인
            guard let data = data else {
                return
            }
            
            do {
                // 결과값을 파싱
                let apiResponse: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
//                NotificationCenter.default.post(name: movieInfoUpdateNotificationKey, object: nil, userInfo: ["Data":apiResponse])
            } catch (let err) {
                print(err.localizedDescription)
//                NotificationCenter.default.post(name: self.movieInfoRequestErrorNotificationKey, object: nil)
            }
        }
        dataTask.resume()
    }
}
