//
//  ViewController.swift
//  ItunesSearchDemo
//
//  Created by Luke Freihofer on 2/20/19.
//  Copyright © 2019 Luke Freihofer. All rights reserved.
//

import UIKit

class ItunesSearchResultsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    var results : [Result] = []
    var timestamp : Date = Date()
    let placeholderText = "Search iTunes Music Store"
    let minTime = 0.1
    let cellHeight = 100
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        
        
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholderText
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func getItunesSearchResults() {
        if Date().timeIntervalSince(timestamp) > minTime {
            timestamp = Date()
            if let query = searchController.searchBar.text {
                NetworkManager.shared.searchItunes(searchTerms: query) { result in
                    DispatchQueue.main.async {
                        self.results.removeAll()
                        self.results.append(contentsOf: result.results!)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //MARK: - SearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        getItunesSearchResults()
    }
    
    
    
    //MARK: - TableViewDatasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! ItunesSearchResultsTableViewCell
        cell.setItunesResultModel(result: results[indexPath.row])
        return cell
    }
    
    
    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getItunesSearchResults()
    }
    

}

