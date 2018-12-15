//
//  Movie.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    static let movieInfoUpdateSuccessNotificationKey: Notification.Name = Notification.Name("movieInfoUpdateSuccess")
    static let movieInfoUpdateErrorNotificationKey: Notification.Name = Notification.Name("movieInfoUpdateError")
    
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
    
    // tableView에서 사용될 평점, 예매 순위, 예매율을 한 문장으로 반환해주는 변수
    var movieInfoForTable: String {
        return "평점: \(self.userRating) 예매 순위: \(self.reservationGrade) 예매율: \(self.reservationRate)"
    }
    
    // collectionView에서 순위, 평점, 예매율을 한 문장으로 반환해주는 변수
    var movieInfoForCollection: String {
        return "\(self.reservationGrade)위(\(self.userRating)) / \(self.reservationRate)%"
    }
    
    // tableView에서 "개봉일"을 붙여 반환해주는 변수
    var dateForTable: String {
        return "개봉일: \(self.date)"
    }
    
    // 영화 포스터이미지를 요청하는 URL을 이용해 이미지를 받아 반환해 주는 변수
    var thumbImage: Data? {
        if let imageURL = URL(string: self.thumb),
            let imageData = try? Data(contentsOf: imageURL) {
            return imageData
        }
        return nil
    }

    // 시청가능 연령이미지의 이름을 반환해주는 변수
    var gradeString: String {
        switch self.grade {
        case 0:
            return "ic_allages"
        default:
            return "ic_\(self.grade)"
        }
    }
    
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
    
    static func requestMovieInfo(with id: String) {
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
                NotificationCenter.default.post(name: self.movieInfoUpdateErrorNotificationKey, object: nil)
                return
            }
            
            // API요청후 얻은 결과값이 nil인지 확인
            guard let data = data else {
                return
            }
            
            do {
                // 결과값을 파싱
                let apiResponse: MovieInfo = try JSONDecoder().decode(MovieInfo.self, from: data)
                NotificationCenter.default.post(name: movieInfoUpdateSuccessNotificationKey, object: nil, userInfo: ["Data":apiResponse])
            } catch (let err) {
                print(err.localizedDescription)
                NotificationCenter.default.post(name: self.movieInfoUpdateErrorNotificationKey, object: nil)
            }
        }
        dataTask.resume()
    }
}
