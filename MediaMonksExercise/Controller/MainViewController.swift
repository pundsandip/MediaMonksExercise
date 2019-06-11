//
//  MainViewController.swift
//  MediaMonksExercise
//
//  Created by Sandip Pund on 08/06/19.
//  Copyright © 2019 AmpleSolution. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    let lodingView = LodingView()
    var albums: [Album] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lodingView.show()
        self.view.addSubview(lodingView)
        
        // load albums list from server and display in tableview
        serviceManager.fetchAlbumList { [unowned self] result in
            self.lodingView.hide()
            switch result {
            case .error(let error):
                print("Error: \(error)")
                break
            case .results(let result):
                self.albums = result
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
                break
            }
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
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
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoVC") as! PhotoViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.albumId = self.albums[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}



