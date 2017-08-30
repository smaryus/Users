//
//  UserPostsTableViewController.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import UIKit

class UserPostsTableViewController: UITableViewController {

    var userInfo: UserInfo! {
        didSet(value) {
            assert(self.userInfo != nil)
            
            self.dataSource.fetchPosts(for: self.userInfo) { [weak self] (results, error) in
                guard let `self` = self else { return }
                self.tableView.reloadData()
            }
        }
    }
    private let dataSource = UserPostDataSource(baseUrlString: "https://jsonplaceholder.typicode.com/posts")

    private var results: [UserPost] {
        return self.dataSource.results
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100

         self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserPostTableViewCell else {
            assertionFailure()

            return UITableViewCell()
        }

        let post = self.results[indexPath.row]
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
