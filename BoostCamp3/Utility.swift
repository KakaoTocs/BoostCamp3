//
//  Utility.swift
//  BoostCamp3
//
//  Created by Jinu Kim on 17/12/2018.
//  Copyright © 2018 com.siva.kim. All rights reserved.
//

import UIKit

// 영화 정렬 방법
let orderKind: [String] = ["예매율순", "큐레이션", "개봉일"]

func getImage(url: String) -> Data? {
    if let imageURL = URL(string: url),
        let imageData = try? Data(contentsOf: imageURL) {
        return imageData
    }
    return nil
}

func warringAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
    alertController.addAction(okAction)
    
    return alertController
}
