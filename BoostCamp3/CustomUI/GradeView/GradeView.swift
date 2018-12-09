//
//  GradeView.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

//@IBDesignable
class GradeView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var gradeStarImageViews: [UIImageView]!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        self.backgroundColor = UIColor.blue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        self.backgroundColor = UIColor.red
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GradeView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        for gradeStarImageView in gradeStarImageViews {
            gradeStarImageView.image = #imageLiteral(resourceName: "star_empty")
        }
    }
}
