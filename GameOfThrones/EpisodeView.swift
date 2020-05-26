//
//  EpisodeView.swift
//  GameOfThrones
//
//  Created by Rave BizzDev on 5/24/20.
//  Copyright © 2020 Rave BizzDev. All rights reserved.
//

import UIKit

class EpisodeView: UIViewController {

    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeDescription: UILabel!
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var airdate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodeDescription.text = summary.components(separatedBy: "<p>")[1].components(separatedBy: "</p>")[0]
        episodeName.text = name
        episodeNumber.text = "Season \(season), Episode \(number)"
        airdate.text = "Air Date: \(air)"
        if let url = URL(string: imageURL) {
            episodeImage.load(url: url)
        }
    }
    
    var summary = ""
    var name = ""
    var season = 0
    var number = 0
    var air = ""
    var imageURL = ""
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
