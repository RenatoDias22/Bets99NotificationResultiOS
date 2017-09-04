//
//  ResultsTableViewCell.swift
//  Bets99NotificationResultiOS
//
//  Created by Renato Dias on 31/08/17.
//  Copyright © 2017 Renato Dias. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var timeCasa: UILabel!
    @IBOutlet weak var timeFora: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var id: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        view.layer.cornerRadius = 10

    }

    
    
//    @IBAction func onClick(_ sender: Any) {
//
//        var request = URLRequest(url: URL(string: "http://www.thisismylink.com/postName.php")!)
//        request.httpMethod = "POST"
//        let postString = "id=13&name=Jack"
//        request.httpBody = postString.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {                                                 // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//        }
//        task.resume()
//
//    }

}
