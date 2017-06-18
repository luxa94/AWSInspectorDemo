//
//  MainTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    private static let TEMPLATES_ROW = 0
    private static let RUNS_ROW = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == MainTableViewController.TEMPLATES_ROW {
            goToTemplates()
        } else if indexPath.row == MainTableViewController.RUNS_ROW {
            goToRuns()
        }
    }

    func goToTemplates() {
        performSegue(withIdentifier: "goToTemplates", sender: nil)
    }

    func goToRuns() {
        performSegue(withIdentifier: "goToRuns", sender: nil)
    }

}
