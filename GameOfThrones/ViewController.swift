//
//  ViewController.swift
//  GameOfThrones
//
//  Created by Rave BizzDev on 5/23/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetch()
    }
    
    var episodes = [Episode]()
    
    func fetch() {
        guard let url = URL(string: "https://api.tvmaze.com/shows/82?embed=seasons&embed=episodes") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.episodes = decoded.embedded.episodes
                        self.tableView.reloadData()
                    }
                    return
                }
            }
            print("fetch failed \(String(describing: error?.localizedDescription))")
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = episodes[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EpisodeView") as? EpisodeView else { return }
        let episode = episodes[indexPath.row]
        vc.summary = episode.summary
        vc.name = episode.name
        vc.season = episode.season
        vc.number = episode.number
        vc.air = episode.airdate
        vc.imageURL = episode.image.medium ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}



struct Response: Codable {
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
    let embedded: Embedded
}

struct Embedded: Codable {
    enum CodingKeys: String, CodingKey {
        case episodes
    }
    
    let episodes: [Episode]
}

struct Episode: Codable {
    enum CodingKeys: String, CodingKey {
        case name, season, number, airdate, summary, image
    }
    let name: String
    let season: Int
    let number: Int
    let airdate: String
    let summary: String
    let image: Image
}

struct Image: Codable {
    enum CodingKeys: String, CodingKey {
        case medium
    }
    let medium: String?
}

