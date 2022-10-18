//
//  UpComingVC.swift
//  MovieApp
//
//  Created by Hakan Körhasan on 26.08.2022.
//

import UIKit


class UpComingVC: UIViewController {

    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(upcomingTable)
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        fetchUpcomingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcomingData() {
        NetworkingManager.shared.getUpcomingMovie { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpComingVC: UITableViewDelegate, UITableViewDataSource {
    
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
