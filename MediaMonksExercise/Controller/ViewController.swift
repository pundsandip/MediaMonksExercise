//
//  ViewController.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 08/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var albums: [Albums] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serviceManager = ServiceManager.shared
        serviceManager.fetchAlbumList { [unowned self] result in
            switch result {
            case .error(let error):
                print("Error: \(error)")
                break
            case .results(let result):
                self.albums = result
                self.tableView.reloadData()
                break
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = self.albums[indexPath.row].title
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected Index: \(indexPath)")
    }
}

