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
    
    //Creates the searchbar and sticks it on the tableview header
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholderText
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //Calls the itunes search api, or clears and reload the table if the textfield is empty
    func getItunesSearchResults() {
        if let query = searchController.searchBar.text {
            if query.isEmpty {
                clearAndRefresh()
            } else {
                self.showSpinner(onView: self.tableView)
                NetworkManager().searchItunes(searchTerms: query) { result in
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        self.results.removeAll()
                        if result.results!.isEmpty {
                            self.addNoResultsFoundLabel()
                        } else {
                            self.removeNoResultsLabel()
                            self.results.append(contentsOf: result.results!)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // removes the label from the background if results exist
    func removeNoResultsLabel() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundView = nil
    }
    
    // adds a label to the background if the results come back empty
    func addNoResultsFoundLabel() {
        let rect = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: self.tableView.bounds.height)
        let noResults = UILabel(frame: rect)
        noResults.text = "No Results Found"
        noResults.textColor = UIColor.gray
        noResults.textAlignment = .center
        self.tableView.separatorStyle = .none
        self.tableView.backgroundView = noResults
    }
    
    
    func clearAndRefresh() {
        self.results.removeAll()
        tableView.reloadData()
    }
    
    //Only make an api call if typing has stopped for X amount of time
    //iTunes API only lets free users use 20 calls per minute, and then increases the penalty time if you try and spam calls
    //If this weren't an issue, I'd make the delay 0.5 seconds or a little lower, but 0.75 for this is necessary to not get locked out
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

