//
//  IndicatorTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit

class IndicatorTableViewController: UITableViewController {

    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
    }

    func showIndicator() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor.black
        indicator.startAnimating()

        tableView.backgroundView = indicator
    }

    func hideIndicator() {
        refreshControl?.endRefreshing()
        tableView.backgroundView = nil
    }

}
