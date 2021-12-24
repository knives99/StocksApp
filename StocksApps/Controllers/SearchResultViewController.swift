//
//  SearchResultViewController.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/16.
//

import UIKit

protocol SearchResultViewControllerDelegate:AnyObject {
    
    func searchResultViewControllerDelegateDidSelect(searchResult:SearchResult)
}

class SearchResultViewController: UIViewController {
    
    private var results = [SearchResult]()
    
    weak var delegate : SearchResultViewControllerDelegate?
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results:[SearchResult]){
        self.results = results
        tableView.isHidden = results.isEmpty 
        tableView.reloadData()
        
    }

}

extension  SearchResultViewController :UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        
        let model = results[indexPath.row]
        cell.textLabel?.text = model.displaySymbol
        cell.detailTextLabel?.text = model.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = results[indexPath.row]
        delegate?.searchResultViewControllerDelegateDidSelect(searchResult: model)
    }
    
    
}
