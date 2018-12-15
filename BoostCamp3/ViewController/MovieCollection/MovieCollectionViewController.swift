//
//  MovieCollectionViewController.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 10/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(moviesUpdateSuccessHandler(_:)), name: MoviesManager.moviesUpdateSuccessNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviesUpdateErrorHandler(_:)), name: MoviesManager.moviesUpdateErrorNotificationKey, object: nil)
        if MoviesManager.shared.isEmpty {
            MoviesManager.updateMovies(by: 0)
        }
    }
    
    @objc func moviesUpdateSuccessHandler(_ noti: Notification) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func moviesUpdateErrorHandler(_ noti: Notification) {
        print("Error")
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
