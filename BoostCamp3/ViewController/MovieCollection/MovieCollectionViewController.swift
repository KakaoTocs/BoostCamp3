//
//  MovieCollectionViewController.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 10/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {
    
    static let MovieCollectionViewOrderTypeUpdateNotificationKey: Notification.Name = Notification.Name("MovieCollectionViewOrderTypeUpdate")
    
    var orderType = MoviesManager.shared.orderType {
        didSet {
            MoviesManager.updateMovies(by: self.orderType ?? 0)
            DispatchQueue.main.async {
                self.navigationItem.title = orderKind[self.orderType ?? 0]
            }
            
            NotificationCenter.default.post(name: MovieCollectionViewController.MovieCollectionViewOrderTypeUpdateNotificationKey, object: nil, userInfo: ["Data":self.orderType ?? 0])
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var refresher: UIRefreshControl!
    
    // MARK: - Delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = orderKind[MoviesManager.shared.orderType ?? 0]
        let orderItem = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .plain, target: self, action: #selector(setOderItemAction(_:)))
        self.navigationItem.setRightBarButton(orderItem, animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.activityIndicatorView.layer.cornerRadius = CGFloat(10.0)
        self.activityIndicatorAnimating(isRunning: false)
        
        // refresherControl 인스턴스 생성
        refresher = UIRefreshControl()
        // refresherControl 액션함수 추가 및 동작 조건(값이 바뀔때) 수정
        refresher.addTarget(self, action: #selector(refreshCollectionViewAction), for: UIControl.Event.valueChanged)
        // 메인 뷰에 refresherControl추가
        collectionView.addSubview(refresher)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(moviesUpdateSuccessHandler(_:)), name: MoviesManager.moviesUpdateSuccessNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviesUpdateErrorHandler(_:)), name: MoviesManager.moviesUpdateErrorNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviesTableViewOrderTypeUpdateHandler(_:)), name: MovieTableViewController.MovieTableViewOrderTypeUpdateNotificationKey, object: nil)
        if MoviesManager.shared.isEmpty {
            MoviesManager.updateMovies(by: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MovieInfoViewController.segueIdentifierFromCollection {
            if let indexPath = collectionView.indexPathsForSelectedItems?[0],
                let movieInfoViewController: MovieInfoViewController = segue.destination as? MovieInfoViewController {
                movieInfoViewController.movieId = MoviesManager.shared.movies[indexPath.row].id
            }
        }
    }
    
    // MARK: - ActionMethod
    @objc func moviesUpdateSuccessHandler(_ noti: Notification) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicatorAnimating(isRunning: false)
        }
    }
    
    @objc func moviesUpdateErrorHandler(_ noti: Notification) {
        DispatchQueue.main.async {
            self.activityIndicatorAnimating(isRunning: false)
        }
        let alertController = UIAlertController(title: "네트워크에 문제가 있습니다.", message: "서버에 재요청 하겠습니까?", preferredStyle: .alert)
        let rerequestAction = UIAlertAction(title: "재시도", style: .default, handler: {(alert: UIAlertAction!) in
            DispatchQueue.main.async {
                self.activityIndicatorAnimating(isRunning: true)
            }
            MoviesManager.updateMovies(by: 0)
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(rerequestAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func moviesTableViewOrderTypeUpdateHandler(_ noti: Notification) {
        guard let data = noti.userInfo?["Data"] as? Int else {
            // Error Alert
            return
        }
        OperationQueue.main.addOperation {
            self.navigationItem.title = orderKind[data]
        }
    }
    
    @objc func setOderItemAction(_ sender: UIBarButtonItem) {
        // alert 생성
        let alertController = UIAlertController(title: "정렬 방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        // alert에 추가할 버튼(액션)들 생성
        let reservationRateOrderAction = UIAlertAction(title: "예매율", style: .default, handler: {(alert: UIAlertAction!) in
            self.activityIndicatorAnimating(isRunning: true)
            self.orderType = 0
        })
        let curationOrderAction = UIAlertAction(title: "큐레이션", style: .default, handler: {(alert: UIAlertAction!) in
            self.activityIndicatorAnimating(isRunning: true)
            self.orderType = 1
        })
        let gradeOrderAction = UIAlertAction(title: "개봉일", style: .default, handler: {(alert: UIAlertAction!) in
            self.activityIndicatorAnimating(isRunning: true)
            self.orderType = 2
        })
        // alert에 버튼(액션) 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(reservationRateOrderAction)
        alertController.addAction(curationOrderAction)
        alertController.addAction(gradeOrderAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func refreshCollectionViewAction() {
        activityIndicatorAnimating(isRunning: true)
        DispatchQueue.global().async {
            MoviesManager.updateMovies(by: self.orderType ?? 0)
        }
        refresher.endRefreshing()
    }
    
    // MARK: - Custom Method
    private func activityIndicatorAnimating(isRunning: Bool) {
        if isRunning {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
}

extension MovieCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoviesManager.shared.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        cell.refresh(with: MoviesManager.shared.movies[indexPath.item])
        
        return cell
    }
    
}
