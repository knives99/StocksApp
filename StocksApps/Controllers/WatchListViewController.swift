//
//  ViewController.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/16.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {

    private var searchTimer :Timer?
    private var panel : FloatingPanelController?
    
    private let tableView :UITableView = {
        let table = UITableView()
        return table
    }()
    /// Model
    private var watchlistMap :[String:[String]] = [:]
    
    ///ViewModels
    private var viewModels:[String]  = []
    
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUPpSearchController()
        setUpTableView()
        setUpFloatingPanel()
        setUpTitleView()
        setUpWatchlistData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:  - Private
    
    private func  setUpWatchlistData(){
        let symbols = PersistenceManager.shared.watchlist
        for symbol in symbols {
            //Fetch market data per symbol
            watchlistMap[symbol] = ["some string"]
        }
        tableView.reloadData()
    }
    
    private func setUpTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpFloatingPanel(){
        let vc = NewsViewController(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
        
    }
    
    private func setUpTitleView(){
        let titleView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        
        let label:UILabel = UILabel(frame: CGRect(x: 10, y: 9, width: titleView.width - 20, height: titleView.height))
        titleView.addSubview(label)
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.text = "Stocks"
        navigationItem.titleView = titleView
    }
    
    private func setUPpSearchController(){
        let resultVC = SearchResultViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
    }
}
 
extension WatchListViewController :UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultVC = searchController.searchResultsController as? SearchResultViewController,
                !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        
        //Reset Timer
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            APICaller.shared.search(query: query) { result in
                switch result{
                case .success(let response):
                    DispatchQueue.main.async {
                        resultVC.update(with: response.result)
                    }
                case.failure(let error):
                    DispatchQueue.main.async {
                        resultVC.update(with: [])
                    }
                }
            }

        })

    }

}


extension WatchListViewController:SearchResultViewControllerDelegate{
    func searchResultViewControllerDelegateDidSelect(searchResult: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        let vc = StockdetailsViewController()
        let navVc = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVc, animated: true, completion: nil)
    }
    
    
}


extension WatchListViewController:FloatingPanelControllerDelegate{
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMap.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //O
    }
}
