//
//  GradeView.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 09/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

@IBDesignable
class GradeView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet var gradeStarImageViews: [UIImageView]!
    
    var rate: Double? = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
    func setRate(rate: Double) {
        self.rate = rate
        set(with: Int(rate.rounded()))
    }
    
    private func set(with rate: Int) {
        if rate == 0 {
            return
        }
        gradeStarImageViews.sort { (firstImageView, secondImageView) in
            var order = false
            OperationQueue.main.addOperation {
                order = firstImageView.tag < secondImageView.tag
                
            }
            return order
        }
        let rateS = rate / 2 - 1
        if rate % 2 == 0 {
            OperationQueue.main.addOperation {
                self.gradeStarImageViews[rateS].image = UIImage(named: "star_full")
            }
        } else {
            OperationQueue.main.addOperation {
                self.gradeStarImageViews[rateS + 1].image = UIImage(named: "star_half")
            }
        }
        for index in gradeStarImageViews.indices where index <= rateS {
            OperationQueue.main.addOperation {
                self.gradeStarImageViews[index].image = UIImage(named: "star_full")
            }
        }
    }
    
}
