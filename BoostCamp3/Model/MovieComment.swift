//
//  MovieComment.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

struct MovieComment: Codable {
    
    static let movieCommentsRequestSuccessNotificationKey: Notification.Name = Notification.Name("movieCommentsRequestSuccess")
    static let movieCommentsRequestErrorNotificationKey: Notification.Name = Notification.Name("movieCommentsRequestError")
    
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
    
    static func requestComments(by movieId: String) {
        // API요청 URL
        guard let url: URL = URL(string: "http://connect-boxoffice.run.goorm.io/comments?id=" + movieId) else {
            return
        }
        // 세션 생성
        let session: URLSession = URLSession(configuration: .default)
        // API에 요청해 처리하는 Task생성 및 요청
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // 에러 발생시 출력
            if let error = error {
                print(error.localizedDescription)
                NotificationCenter.default.post(name: movieCommentsRequestErrorNotificationKey, object: nil)
                return
            }
            
            // API요청후 얻은 결과값이 nil인지 확인
            guard let data = data else {
                return
            }
            
            do {
                // 결과값을 파싱
                let apiResponse: MovieComments = try JSONDecoder().decode(MovieComments.self, from: data)
                NotificationCenter.default.post(name: movieCommentsRequestSuccessNotificationKey, object: nil, userInfo: ["Data":apiResponse, "movieId":movieId])
            } catch (let err) {
                print(err.localizedDescription)
                NotificationCenter.default.post(name: self.movieCommentsRequestErrorNotificationKey, object: nil)
            }
        }
        dataTask.resume()
    }
}

class MovieComments: Codable {
    var comments: [MovieComment] = []
}
