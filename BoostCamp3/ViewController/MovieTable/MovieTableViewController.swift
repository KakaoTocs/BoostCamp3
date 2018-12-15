//
//  ViewController.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 08/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        MoviesManager.updateMovies(by: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(moviesUpdateSuccessHandler(_:)), name: MoviesManager.moviesUpdateSuccessNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moviesUpdateErrorHandler(_:)), name: MoviesManager.moviesUpdateErrorNotificationKey, object: nil)
        
        if MoviesManager.shared.isEmpty {
            MoviesManager.updateMovies(by: 0)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("DD")
    }
    
    @objc func moviesUpdateSuccessHandler(_ noti: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func moviesUpdateErrorHandler(_ noti: Notification) {
        print("Error")
    }

}

extension MovieTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoviesManager.shared.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.refresh(with: MoviesManager.shared.movies[indexPath.row])
        
        return cell
    }
    
}
