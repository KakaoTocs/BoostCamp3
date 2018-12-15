//
//  InfoViewController.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 08/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(movieInfoRequestSuccessHandler(_:)), name: MovieInfo.movieInfoRequestSuccessNotificationKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movieInfoRequestErrorHandler(_:)), name: MovieInfo.movieInfoRequestErrorNotificationKey, object: nil)
    }


    @objc func movieInfoRequestSuccessHandler(_ noti: Notification) {
        guard let data = noti.userInfo?["Data"] as? MovieInfo else {
            // Error Alert
            return
        }
        
        self.movieComment = data.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func movieInfoRequestErrorHandler(_ noti: Notification) {
        
    }
}
