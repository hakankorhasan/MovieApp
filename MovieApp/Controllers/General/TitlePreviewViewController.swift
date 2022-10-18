//
//  TitlePreviewViewController.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 4.10.2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private var headerView: HeroHeaderUIView?
    
    
    private let MovieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let webView: WKWebView = {
           let webView = WKWebView()
           webView.translatesAutoresizingMaskIntoConstraints = false
           return webView
       }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
               button.translatesAutoresizingMaskIntoConstraints = false
               button.backgroundColor = AppColorTheme()
               button.setTitle("Favorite", for: .normal)
               button.setTitleColor(.white, for: .normal)
               button.layer.cornerRadius = 8
               button.layer.masksToBounds = true
        return button
    }()
  
    private let titleLabel: UILabel = {
           
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 22, weight: .bold)
            label.text = "Harry potter"
            return label
    }()
    
    private let ratingIcon: UIButton = {
        let icon = UIButton()
        let image = UIImage(systemName: "star",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        icon.setImage(image, for: .normal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .yellow
        return icon
    }()
    
    private let ratingTextLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .yellow
        return label
    }()
    
        
        private let overviewLabel: UILabel = {
           
            let label = UILabel()
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "This is the best movie ever to watch as a kid!"
            return label
        }()
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
                view.addSubview(webView)
                view.addSubview(titleLabel)
                view.addSubview(overviewLabel)
                view.addSubview(favoriteButton)
        view.addSubview(ratingIcon)
        view.addSubview(ratingTextLabel)
                configureConstraints()
        
    }
    
    func configureConstraints() {

            let webViewConstraints = [
                webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.heightAnchor.constraint(equalToConstant: 300)
            ]
            
            let titleLabelConstraints = [
                titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ]
        
        let ratingConstraints = [
          //  ratingIcon.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            ratingIcon.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20)
        ]
            
            let overviewLabelConstraints = [
                overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            
            let downloadButtonConstraints = [
                favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                favoriteButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
                favoriteButton.widthAnchor.constraint(equalToConstant: 140),
                favoriteButton.heightAnchor.constraint(equalToConstant: 40)
            ]
        
            NSLayoutConstraint.activate(webViewConstraints)
            NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(ratingConstraints)
            NSLayoutConstraint.activate(overviewLabelConstraints)
            NSLayoutConstraint.activate(downloadButtonConstraints)
            
        }
        

    func configure(with model: TitlePreviewViewModels) {
        
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return}
        
        webView.load(URLRequest(url: url))
    }
    
   
}
