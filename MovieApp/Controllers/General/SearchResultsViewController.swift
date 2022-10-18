//
//  SearchResultsViewController.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 29.09.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func SearchResultsViewControllerDidTapCell(_ viewModel: TitlePreviewViewModels)
}


class SearchResultsViewController: UIViewController {
    
    public var titles: [Title] = [Title]()
    public weak var delegate: SearchResultsViewControllerDelegate?
    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
   
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchResultsCollectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        NetworkingManager.shared.getMovieTrailer(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    self?.delegate?.SearchResultsViewControllerDidTapCell(TitlePreviewViewModels(
                        title: title.original_title ?? "",
                        youtubeView: videoElement,
                        titleOverview: title.overview ?? ""))
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
   
}
