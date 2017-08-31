//
//  UsersViewController.swift
//  UsersPosts
//
//  Created by Marius Sincovici on 30/08/2017.
//  Copyright © 2017 Marius Sincovici. All rights reserved.
//

import UIKit

private struct Constants {
    static let usersListStringUrl = "https://jsonplaceholder.typicode.com/users"
}

final class UsersViewController: UITableViewController {

    private var detailViewController: UserPostsTableViewController? = nil

    private var datasource = UsersDataSource(serverUrl: URL(string: Constants.usersListStringUrl)!)

    fileprivate var results: [UserInfo] {
        return self.datasource.results
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140

        self.datasource.fetchUsers { [weak self] (results, error) in
            assert(Thread.isMainThread)

            self?.tableView.reloadData()
        }

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? UserPostsTableViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let userInfo = self.results[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! UserPostsTableViewController
                controller.userInfo = userInfo
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }

        let userInfo = self.results[indexPath.row]
        cell.nameLabel.text = userInfo.name
        cell.userNameLabel.text = userInfo.userName
        cell.emailLabel.text = userInfo.email

        if let address = userInfo.address {
            let fullAddress = "\(address.street), \(address.suite), \(address.city), \(address.zipCode)"
            cell.addressLabel.text = fullAddress
        }

        return cell
    }
}

