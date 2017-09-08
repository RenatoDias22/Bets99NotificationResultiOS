//
//  ViewController.swift
//  Bets99NotificationResultiOS
//
//  Created by Renato Dias on 31/08/17.
//  Copyright © 2017 Renato Dias. All rights reserved.
//

import UIKit
import JSONJoy
import SwiftHTTP
import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    var jogos: [Jogo] = [Jogo]()
    var index = 0
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        tableView.delegate = self;
        tableView.dataSource = self;
        getResults()
        tableView.separatorColor = UIColor.white
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Reload...",attributes: nil)
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        getResults()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        getResults()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath) as! ResultsTableViewCell
        
        let jogo = jogos[indexPath.row];
        
        if let id = jogo.id {
            cell.id.text = "(\(id))"
        }
        
        if let nameHomeTeam = jogo.nameHomeTeam {
            cell.timeCasa.text = nameHomeTeam
        }
        
        if let nameFgTeam =  jogo.nameFgTeam {
            cell.timeFora.text = nameFgTeam
        }
        
        if let startDate = jogo.startDate {
            cell.data.text = startDate
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let timeCasa = jogos[indexPath.row].nameHomeTeam{
            UserDefaults.standard.setValue(timeCasa, forKey: "time_casa_selecionado")
        }
        if let timeFora = jogos[indexPath.row].nameFgTeam {
            UserDefaults.standard.setValue(timeFora, forKey: "time_fora_selecionado")
        }
        if let data = jogos[indexPath.row].startDate {
            UserDefaults.standard.setValue(data, forKey: "data_selecionado")
        }
        if let id = jogos[indexPath.row].id {
            UserDefaults.standard.setValue(id, forKey: "id_selecionado")
        }

    }
    
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jogos.count
    }
    
    
    // REQUEST: - Requisicao get
    func getResults() {
        //        SVProgressHUD.show()
        do {
            
            let urlString = "http://api.bets99.com/index.php/apimobile/listNoResultGames"
            let url = URL(string: urlString)
            
            URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    let matches = json["matches"] as? [[String: Any]] ?? []
                    
                    self.jogos = Array<Jogo>()
                    
                    for matche in matches {
                        let jogo = Jogo()
                        
                        if let id = matche["id"] as? String {
                            jogo.id = id
                        }
                        if let nameHomeTeam = matche["nameHomeTeam"] as? String {
                            jogo.nameHomeTeam = nameHomeTeam
                        }
                        if let nameFgTeam =  matche["nameFgTeam"] as? String {
                            jogo.nameFgTeam = nameFgTeam
                        }
                        if let startDate =  matche["startDate"] as? String {
                            jogo.startDate = startDate
                        }
                        
                        self.jogos.append(jogo)
                    }
                    
                    SVProgressHUD.dismiss()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                } catch let error as NSError {
                    print(error)
                }
            }).resume()
        }
        
    }
    
    class Jogo {
        
        var id: String?
        var nameHomeTeam: String?
        var nameFgTeam: String?
        var startDate: String?
        
        init() {
            
        }
        
    }
}
