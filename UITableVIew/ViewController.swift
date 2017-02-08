//
//  ViewController.swift
//  UITableVIew
//
//  Created by Admin on 07.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import LoremIpsum
import Kingfisher

struct Item {
    
    var imageURL: String
    var topTitle: String
    var bottomTitle: String
}


class ViewController: UIViewController {
    
    var items = [Item]()
    
    private let pageSize: Int = 25
    fileprivate let templateCell = TableViewCell()
    fileprivate var isLoadingItems = false

    var imageURLs: [String] = ["https://pp.vk.me/c637422/v637422170/2a5ef/zCFQOF8HayM.jpg",
                               "https://pp.vk.me/c636218/v636218360/3812a/1lXo4VmdZLE.jpg",
                               "https://pp.vk.me/c543105/v543105726/16235/N7xHdQ4rlFw.jpg",
                               "https://pp.vk.me/c418722/v418722504/8575/wSwQxKceOwg.jpg",
                               "https://cs541603.vk.me/c540105/v540105502/9ab47/DmbJ6RLc2cw.jpg",
                               "https://cs541603.vk.me/c540104/v540104577/506d3/SU0XG9_HCuE.jpg",
                               "https://pp.vk.me/c635106/v635106115/824b/42aahI0lgys.jpg",
                               "https://cs541603.vk.me/c635103/v635103881/a22e/bupItSCEVPc.jpg"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentItemsCountLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        loadNextPage { }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    fileprivate func loadNextPage(completion: @escaping () -> Void) {
        var items = [Item]()
        for _ in 0..<pageSize {
            let imageURL = imageURLs[Int(arc4random_uniform(UInt32(imageURLs.count)))]
            let item = Item(imageURL: imageURL,
                            topTitle: LoremIpsum.sentences(withNumber: 2)!,
                            bottomTitle: LoremIpsum.sentences(withNumber: 2)!)
            items.append(item)
        }
        DispatchQueue.main.async {
            self.insert(items: items)
            self.currentItemsCountLabel.text = "Current items count: \(self.items.count)"
            completion()
        }
    }
    
    fileprivate func insert(items: [Item]) {
        tableView.beginUpdates()
        var indexPaths = [IndexPath]()
        for i in 0..<items.count {
            let indexPath = IndexPath(row: self.items.count + i, section: 0)
            indexPaths.append(indexPath)
        }
        tableView.insertRows(at: indexPaths, with: .fade)
        self.items.append(contentsOf: items)
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableViewHeight = scrollView.bounds.height
        if !isLoadingItems && (scrollView.contentOffset.y + tableViewHeight > scrollView.contentSize.height - tableViewHeight * 2) {
            DispatchQueue.global(qos: .background).async {
                self.isLoadingItems = true
                self.loadNextPage {
                    self.isLoadingItems = false
                }
            }

        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let item = items[indexPath.row]
        cell.set(topTitle: item.topTitle,
                 bottomTitle: item.bottomTitle,
                 imageURL: URL(string: item.imageURL)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        templateCell.prepareLayout(topTitle: item.topTitle, bottomTitle: item.bottomTitle)
        return templateCell.frame.size.height
    }
}
