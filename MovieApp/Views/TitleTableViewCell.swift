//
//  TitleTableViewCell.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 28.09.2022.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    
    private let playButton: UIButton = {
        let buttom = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        buttom.setImage(image, for: .normal)
        buttom.translatesAutoresizingMaskIntoConstraints = false
        buttom.tintColor = AppColorTheme()
        return buttom
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let titlePosterUIImage: UIImageView  = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterUIImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingTextLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let titlePosterUIImageConstraints = [
            titlePosterUIImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUIImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterUIImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterUIImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterUIImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 18)
        ]
        
        let ratingIconConstraints = [
            ratingIcon.leadingAnchor.constraint(equalTo: titlePosterUIImage.trailingAnchor, constant: 20),
            ratingIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        let ratingTextLabelConstraints = [
            ratingTextLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 5),
            ratingTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ]
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterUIImageConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(ratingIconConstraints)
        NSLayoutConstraint.activate(ratingTextLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {return}
        
        titlePosterUIImage.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
        let rating = String(format: "%.1f", model.vote_average)
        ratingTextLabel.text = "\(rating)"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
