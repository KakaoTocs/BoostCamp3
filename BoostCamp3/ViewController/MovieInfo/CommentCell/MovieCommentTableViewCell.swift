//
//  CommentTableViewCell.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

class MovieCommentTableViewCell: UITableViewCell {

    static let identifier = "MovieCommentCell"
    
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var ratingLabel: GradeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh(with comment: MovieComment) {
        self.writerLabel.text = comment.writer
        self.timestampLabel.text = unixtimeToDate(time: comment.timestamp)
        self.contentsLabel.text = comment.contents
        self.ratingLabel.setRate(rate: comment.rating)
    }
    
    // MARK: - Custom Method
    private func unixtimeToDate(time: Double) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = Date(timeIntervalSince1970: time)
        let result = dateFormatter.string(from: date)
        
        return result
    }
}
