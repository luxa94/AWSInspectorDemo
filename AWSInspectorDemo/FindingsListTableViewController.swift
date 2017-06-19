//
//  FindingsListTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/19/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit
import Alamofire

class FindingsListTableViewController: IndicatorTableViewController {

    let requestProcessor = RequestProcessor()
    var findingArns: [String] = []
    var runArn: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
    }

    override func viewWillAppear(_ animated: Bool) {
        showIndicator()
        fetchFindings()
    }

    func fetchFindings() {
        requestProcessor.sendRequest(request: .listFindings, parameters: ["assessmentRunArns": [runArn]])
        .responseJSON(completionHandler: findingsFetched)
    }

    func findingsFetched(response: DataResponse<Any>) {
        hideIndicator()
        guard let json = response.result.value as? [String: AnyObject],
            let arns = json["findingArns"] as? [String]
            else {
                showSimpleAlertWithTitle(message: "Unable to fetch findings.", viewController: self)
                return
        }

        findingArns = arns
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findingArns.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindingCell", for: indexPath)

        cell.textLabel?.text = findingArns[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFindingDetails", sender: findingArns[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFindingDetails" {
            if let vc = segue.destination as? FindingDetailsTableViewController {
                vc.findingArn = sender as? String
            }
        }
    }

}
