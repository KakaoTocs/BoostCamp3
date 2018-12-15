//
//  Movies.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

class MoviesManager {
    
    static let moviesUpdateSuccessNotificationKey: Notification.Name = Notification.Name("moviesUpdateSuccess")
    static let moviesUpdateErrorNotificationKey: Notification.Name = Notification.Name("moviesUpdateError")
    
    static let shared = MoviesManager()
    
    var movies: [Movie] = []
    var orderType: Int?
    var isEmpty: Bool {
        get {
            return movies.count > 0 ? false : true
        }
    }
    
    static func updateMovies(by orderType: Int) {
        // API요청 URL
        guard let url: URL = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else {
            return
        }
        // 세션 생성
        let session: URLSession = URLSession(configuration: .default)
        // API에 요청해 처리하는 Task생성
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            // 에러 발생시 출력
            if let error = error {
                // Noti로 에러 알림 -> 재요청 or 취소 선택
                print(error.localizedDescription)
                NotificationCenter.default.post(name: moviesUpdateErrorNotificationKey, object: nil)
                return
            }
            
            // API요청후 얻은 결과값이 nil인지 확인
            guard let data = data else {
                return
            }
            
            do {
                // 결과값을 파싱
                let apiResponse: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                // 싱글톤에 결과값 업데이트
                self.shared.movies = apiResponse.movies
                self.shared.orderType = apiResponse.orderType
                // NotificationCenter에 업데이트 된것을 알림
                NotificationCenter.default.post(name: moviesUpdateSuccessNotificationKey, object: nil)
            } catch(let err) {
                // Noti로 에러 알림 -> 재요청 or 취소 선택
                print(err.localizedDescription)
                NotificationCenter.default.post(name: moviesUpdateErrorNotificationKey, object: nil)
            }
        }
        dataTask.resume()
    }
}
