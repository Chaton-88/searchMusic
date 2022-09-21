//
//  ViewController.swift
//  searchMusic
//
//  Created by Valeriya Trofimova on 04.06.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    let networkDataFetcher  = NetworkDataFetcher()
    var searchResponse: SearchResponse? = nil
    private var timer: Timer?

    let tableView = UITableView(frame: .zero, style: .plain)
    private let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Search music"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        setupSearchBar()
    }

    // MARK: - setup views
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - setup search bar
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        // появляется сразу без скролла
        navigationItem.hidesSearchBarWhenScrolling = false
        // при вводе не пропадает navigationBar
        //searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
}
      
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let track = searchResponse?.results[indexPath.row]
        cell.textLabel?.text = track?.trackName
        cell.detailTextLabel?.text = "\(track?.artistName ?? ""), \(track?.primaryGenreName ?? "")"
       
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&limit=10"
        //request(urlString: urlString) { searchResponse, error in
        //searchResponse?.results.map({ (track) in
        //print(track.trackName)
        //})
        //}
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchTracks(urlString: urlString, response: { [weak self] (searchResponse) in
                //searchResponse.results.map({ (track) in
                //print("track.trackName:", track.trackName)
                //})
                guard let searchResponse = searchResponse else { return }
                self?.searchResponse = searchResponse
                self?.tableView.reloadData()
            })
        }
        )}
}


