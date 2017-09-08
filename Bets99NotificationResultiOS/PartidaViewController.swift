//
//  PartidaViewController.swift
//  Bets99NotificationResultiOS
//
//  Created by Renato Dias on 04/09/17.
//  Copyright © 2017 Renato Dias. All rights reserved.
//

import UIKit

class PartidaViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var timeCasa: UILabel!
    @IBOutlet weak var timeFora: UILabel!
    
    @IBOutlet weak var dataPartida: UILabel!
    
    @IBOutlet weak var viewContaner: UIView!
    var id: String = ""
    
    @IBOutlet weak var viewResults: UIView!
    
    
    @IBOutlet weak var textFieldPrimeiroTempo: UITextField!
    
    @IBOutlet weak var textFieldSegundoTempo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewContaner.layer.cornerRadius = 10
        
        viewResults.layer.cornerRadius = 10
//        
        textFieldSegundoTempo.delegate = self as? UITextFieldDelegate
        
        textFieldSegundoTempo.delegate = self as? UITextFieldDelegate
        
        id = (UserDefaults.standard.value(forKey: "id_selecionado") as? String)!
        dataPartida.text = UserDefaults.standard.value(forKey: "data_selecionado") as? String
        timeCasa.text = UserDefaults.standard.value(forKey: "time_casa_selecionado") as? String
        timeFora.text = UserDefaults.standard.value(forKey: "time_fora_selecionado") as? String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
        
    {
        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789")
        let stringFromTextField = NSCharacterSet.init(charactersIn: string)
        let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
        
        return strValid
    }
    
    
    @available(iOS 2.0, *)
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("Begin : ", textView.text)
        return true
    }
    
    @available(iOS 2.0, *)
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("End : ", textView.text)
        return true
    }
    
    
    @available(iOS 2.0, *)
    public func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing : ", textView.text)
    
    }
    
    @available(iOS 2.0, *)
    public func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing : ", textView.text)
    }

    @IBAction func EnviarResultados(_ sender: Any) {
        
        if textFieldSegundoTempo.text != "" || textFieldSegundoTempo.text != "" {
        
            var request = URLRequest(url: URL(string: "http://www.thisismylink.com/postName.php")!)
            request.httpMethod = "POST"
            //        let postString = "id=\(id)&resultprimeirotempo=\(String(describing: timeCasa.text))&resultsegundotempo=\(String(describing: timeFora.text))"
            
            //        request.httpBody = postString.data(using: .utf8)
            
            request.httpBody = "id=\(id)&resultprimeirotempo=\(String(describing: textFieldSegundoTempo))&resultsegundotempo=\(String(describing: textFieldSegundoTempo))".data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
        } else {
            alert(message: "Preencha primeiro e segundo tempo.")
        }
        
    }

    @IBAction func PesquisarPartida(_ sender: Any) {
        
        
        let casa: String = timeCasa.text!
        
        let casaReplaced = String(casa.characters.map {
            $0 == " " ? "+" : $0
        })
        
        let fora: String  = timeFora.text!
        
        let foraReplaced = String(fora.characters.map {
            $0 == " " ? "+" : $0
        })
        
        let data: String  = dataPartida.text!
        
        let data1 = data.replacingOccurrences(of: "/", with: "%2F")
       
        let endIndex = data1.index(data1.endIndex, offsetBy: -6)
        let truncated = data1.substring(to: endIndex)

        if let url = NSURL(string: "http://www.google.com/search?q=\(casaReplaced)+vs+\(foraReplaced)+\(truncated)"){
            
            
            UIApplication.shared.open(url as URL)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

