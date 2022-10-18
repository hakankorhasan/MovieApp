//
//  WhatcListVC.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 26.08.2022.
//

import UIKit

class WhatcListVC: UIViewController {

    private var favoriteTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    private var titles: [TitleItem] = [TitleItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "My Watchlist"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(favoriteTableView)
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        fetchLocalStorageForFavorite()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Favorited"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForFavorite() 
        }
    }
    
    private func fetchLocalStorageForFavorite() {
        CoreDataPersistanceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.favoriteTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoriteTableView.frame = view.bounds
    }
    
}

extension WhatcListVC: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            CoreDataPersistanceManager.shared.deleteMovie(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("success to delete data")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
                
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
