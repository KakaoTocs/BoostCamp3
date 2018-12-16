//
//  MovieInfoViewController.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 08/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {
    
    static let segueIdentifierFromTable = "MovieInfoFromTable"
    static let segueIdentifierFromCollection = "MovieInfoFromCollection"
    
    var movieId: String?
    var movieComments: MovieComments? {
        didSet {
            OperationQueue.main.addOperation {
                self.tableViewHeightConstraint.constant = CGFloat((self.movieComments?.comments.count ?? 0) * 95)
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var genreDurationLabel: UILabel!
    @IBOutlet weak var reservationInfoLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var gradeView: GradeView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Delegate
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicatorView.layer.cornerRadius = CGFloat(10.0)
        tableView.register(UINib(nibName: "MovieCommentTableViewCell", bundle: nil), forCellReuseIdentifier: MovieCommentTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.backItem?.title = "영화목록"
        let backButton = UIBarButtonItem()
        backButton.title = "영화목록"
        self.navigationController?.navigationItem.backBarButtonItem = backButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(movieInfoRequestSuccessHandler(_:)), name: MovieInfo.movieInfoRequestSuccessNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movieInfoRequestErrorHandler(_:)), name: MovieInfo.movieInfoRequestErrorNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movieCommentsRequestSuccessHandler(_:)), name: MovieComment.movieCommentsRequestSuccessNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movieCommentsRequestErrorHandler(_:)), name: MovieComment.movieCommentsRequestErrorNotificationKey, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = self.movieId {
            activityIndicatorAnimating(isRunning: true)
            MovieInfo.requestMovieInfo(by: id)
            MovieComment.requestComments(by: id)
        }
    }
    
    // MARK: - Action Method
    @objc func movieInfoRequestSuccessHandler(_ noti: Notification) {
        activityIndicatorAnimating(isRunning: false)
        guard let data = noti.userInfo?["Data"] as? MovieInfo else {
            // Error Alert
            return
        }
        OperationQueue.main.addOperation {
            self.updateView(with: data)
        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
    
    @objc func movieInfoRequestErrorHandler(_ noti: Notification) {
        activityIndicatorAnimating(isRunning: false)
        let alertController = UIAlertController(title: "영화정보를 가져오는데 오류가 있습니다.", message: "서버에 재요청 하겠습니까?", preferredStyle: .alert)
        let rerequestAction = UIAlertAction(title: "재시도", style: .default, handler: {(alert: UIAlertAction!) in
            DispatchQueue.main.async {
                self.activityIndicatorAnimating(isRunning: true)
            }
            if let id = self.movieId {
                MovieInfo.requestMovieInfo(by: id)
            } else {
                let idErrorAlertController = UIAlertController(title: "앱에 문제가 있습니다.", message: "앱을 종료후 재 실행 해주세요", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel , handler: nil)
                idErrorAlertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(rerequestAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func movieCommentsRequestSuccessHandler(_ noti: Notification) {
        activityIndicatorAnimating(isRunning: false)
        guard let data = noti.userInfo?["Data"] as? MovieComments else {
            // Error Alert
            return
        }
        self.movieComments = data
    }
    
    @objc func movieCommentsRequestErrorHandler(_ noti: Notification) {
        activityIndicatorAnimating(isRunning: false)
        
        let alertController = UIAlertController(title: "영화 한줄평을 가져오는데 오류가 있습니다.", message: "서버에 재요청하겠습니까?", preferredStyle: .alert)
        let rerequestAction = UIAlertAction(title: "재시도", style: .default, handler: {(alert: UIAlertAction!) in
            DispatchQueue.main.async {
                self.activityIndicatorAnimating(isRunning: true)
            }
            if let id = self.movieId {
                MovieComment.requestComments(by: id)
            } else {
                let idErrorAlertController = UIAlertController(title: "앱에 문제가 있습니다.", message: "앱을 종료후 재 실행 해주세요", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel , handler: nil)
                idErrorAlertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(rerequestAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Custom Method
    private func updateView(with movieInfo: MovieInfo) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        self.titleLabel.text = movieInfo.title
        self.navigationItem.title = movieInfo.title
        self.titleLabel.numberOfLines = 1
        self.titleLabel.adjustsFontSizeToFitWidth = true
        
        DispatchQueue.global().async {
            if let thumbImageData = getImage(url: movieInfo.image) {
                OperationQueue.main.addOperation {
                    self.thumbImageView.image = UIImage(data: thumbImageData)
                }
            }
        }
        self.gradeImageView.image = UIImage(named: movieInfo.gradeString)
        self.dateLabel.text = movieInfo.date + "개봉"
        self.genreDurationLabel.text = movieInfo.genre + "\(movieInfo.duration)분"
        self.reservationInfoLabel.text = "\(movieInfo.reservationGrade)위 " + "\(movieInfo.reservationRate)%"
        self.userRatingLabel.text = "\(movieInfo.userRating)"
        self.audienceLabel.text = numberFormatter.string(from: NSNumber(value: movieInfo.audience))?.description
        self.gradeView.setRate(rate: movieInfo.userRating)
        self.synopsisLabel.text = movieInfo.synopsis
        self.synopsisLabel.sizeToFit()
        self.directorLabel.text = movieInfo.director
        self.actorLabel.text = movieInfo.actor
        self.actorLabel.sizeToFit()
    }
    
    func activityIndicatorAnimating(isRunning: Bool) {
        if isRunning {
            DispatchQueue.main.async {
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
}

extension MovieInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieComments?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MovieCommentTableViewCell.identifier, for: indexPath) as? MovieCommentTableViewCell,
            let comment = movieComments?.comments[indexPath.row] else {
            return UITableViewCell()
        }
        cell.refresh(with: comment)
        
        return cell
    }
}

