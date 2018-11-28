//
//  MainViewController.swift
//  MusicMenu
//
//  Created by Mike on 2018/11/15.
//  Copyright © 2018 Mike. All rights reserved.
//

import UIKit

protocol MainBehavior {
    func searchMusic(keyword: String, completion: @escaping (_ results: [MusicInfo]) -> Void )
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "main_menu" }
    
    @IBOutlet weak var tblVwSearchResult: UITableView!
    @IBOutlet weak var idcVwLoading: UIActivityIndicatorView!
    
    private var viewModel: MainBehavior?
    private var searchController: UISearchController!
    
    var musicInfos = [MusicInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "iTunes music search"
        self.viewModel = MainViewModel()
        self.idcVwLoading.hidesWhenStopped = true
        self.searchControllerInit()
        self.tableViewCellRegister()
        self.removeTableViewBlank()
    }
    
    private func tableViewCellRegister() {
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        self.tblVwSearchResult.register(nib, forCellReuseIdentifier: "searchResultCell")
    }
    
    private func removeTableViewBlank() {
        self.tblVwSearchResult.tableFooterView = UIView()
    }
    
    private func searchControllerInit() {
        
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tblVwSearchResult.tableHeaderView = searchController.searchBar

//        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
//        searchController.searchBar.backgroundImage = UIImage()
//        searchController.searchBar.backgroundColor = UIColor(hexString: "426680")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResult(results: [MusicInfo]) {
        self.musicInfos = results
        self.tblVwSearchResult.reloadData()
    }
    
    //MARK: - button actions
    
    func tapSearch(keyword: String) {
        
        self.idcVwLoading.startAnimating()
        self.viewModel?.searchMusic(keyword: keyword, completion: { [weak self] (results) in
            
            self?.updateSearchResult(results: results)
            self?.idcVwLoading.stopAnimating()
        })
    }
    
    

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicInfos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.IDENTIFIER, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let musicInfo = musicInfos[indexPath.row]
        cell.setup(musicInfo: musicInfo)
        
//        if let searchWord = searchController.searchBar.text, searchWord.isEmpty {
//            morePresenterCasting?.touchScrollEvent(section: indexPath.section, forMore: summaries!.count / 2 == indexPath.row)
//        }
        
        return cell
        
    }
    
    // MARK: - UISearchBarDelegate
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let searchText = searchController.searchBar.text {
            self.tapSearch(keyword: searchText)
        }
    }

}

