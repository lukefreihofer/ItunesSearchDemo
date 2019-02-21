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
    let placeholderText = "Search iTunes Music Store"
    let detailsSegueName = "resultDetailsSegue"
    let cellHeight = 100
    let searchController = UISearchController(searchResultsController: nil)
    var searchTask : DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        self.definesPresentationContext = true
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
        if let query = searchController.searchBar.text {
            if query.isEmpty {
                clearAndRefresh()
            } else {
                NetworkManager().searchItunes(searchTerms: query) { result in
                    DispatchQueue.main.async {
                        self.results.removeAll()
                        if result.results!.isEmpty {
                            self.addNoResultsFoundLabel()
                        } else {
                            self.tableView.backgroundView = nil
                            self.results.append(contentsOf: result.results!)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func addNoResultsFoundLabel() {
        let rect = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: self.tableView.bounds.height)
        let noResults = UILabel(frame: rect)
        noResults.text = "No Results Found"
        noResults.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noResults.textAlignment = .center
        self.tableView.backgroundView = noResults
    }
    
    
    func clearAndRefresh() {
        self.results.removeAll()
        tableView.reloadData()
    }
    
    func delaySearchCall() {
        
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.getItunesSearchResults()
        }
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: self.searchTask!)
    }
    
    //MARK: - SearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        delaySearchCall()
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
        self.performSegue(withIdentifier: detailsSegueName, sender: self)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getItunesSearchResults()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearAndRefresh()
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsSegueName {
            let vc = segue.destination as! ItunesSearchResultsDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            let searchResult = results[indexPath.row]
            vc.searchResult = searchResult
            
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.searchController.searchBar.endEditing(true)
        }
    }

}

