//
//  TopStoriesNewsViewController.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/16.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    enum `Type`{
        case topStories
        case compan(symbol:String)
        
        var title:String{
            switch self{
            case .topStories:
                return "Top Stories"
            case.compan(let symbol):
                return symbol.uppercased()
            }
        }
    }
//MARK: - Properties
    private var stories = [NewsStory]()
    
    private let type:Type
    
    let tableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        
        return table
    }()
    

    
    
    //MARK: - INit
    init(type:Type){
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        fetcNews()


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - Private
    
    private func setUpTable(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetcNews(){
        APICaller.shared.news(for: type) { [weak self]result in
            switch result{
            case.success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func open(url:URL){
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    

}

extension NewsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as! NewsStoryTableViewCell
        let model = stories[indexPath.row]
        cell.configure(with: .init(model: model))
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else{
            return nil
        }
        header.configure(with: .init(title: self.type.title, shouldShowAddButton: false))
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = stories[indexPath.row]
        guard let url = URL(string: story.url) else {
            presentFaildeToOpenAlert()
            return}
        
        open(url: url)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    private func  presentFaildeToOpenAlert(){
        let alert = UIAlertController(title: "Unable to open", message: "We were unable to open the article.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

