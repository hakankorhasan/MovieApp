//
//  SearchVC.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 26.08.2022.
//

import UIKit

class SearchVC: UIViewController {

    private var titles: [Title] = [Title]()
    
    private let discoverTableView: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchBarView: UISearchController = {
       
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        navigationItem.searchController = searchBarView
        navigationController?.navigationBar.tintColor = AppColorTheme()
        
        searchBarView.searchResultsUpdater = self
        fetchUpcomingData()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
    private func fetchUpcomingData() {
        NetworkingManager.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknow", posterURL: title.poster_path ?? "", vote_average: title.vote_average))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        discoverTableView.deselectRow(at: indexPath, animated: true)
                
                let title = titles[indexPath.row]
                
                guard let titleName = title.original_title ?? title.original_name else {
                    return
                }
                
                
                NetworkingManager.shared.getMovieTrailer(with: titleName) { [weak self] result in
                    switch result {
                    case .success(let videoElement):
                        DispatchQueue.main.async {
                            let vc = TitlePreviewViewController()
                            vc.configure(with: TitlePreviewViewModels(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }

                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
    }
    
}


extension SearchVC: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 2,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
        
        
        resultsController.delegate = self
        
        NetworkingManager.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func SearchResultsViewControllerDidTapCell(_ viewModel: TitlePreviewViewModels) {
        
        DispatchQueue.main.async { [weak self ] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
