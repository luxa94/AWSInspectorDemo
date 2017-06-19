//
//  FindingDetailsTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/20/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit
import Alamofire

class FindingDetailsTableViewController: IndicatorTableViewController {

    private static let DETAILS_SECTION = 0
    private static let ATTRIBUTES_SECTION = 1
    private static let USER_ATTRIBUTES_SECTION = 2

    var findingArn: String!
    let requestProcessor = RequestProcessor()
    var finding: Finding?
    var attributes: [StringString] = []
    var userAttributes: [StringString] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        tableView.register(UINib(nibName: "SubtitleCell", bundle: nil), forCellReuseIdentifier: "SubtitleCell")

        tableView.estimatedRowHeight = 60
    }

    override func viewWillAppear(_ animated: Bool) {
        showIndicator()
        requestProcessor.sendRequest(request: .describeFindings, parameters: ["findingArns": [findingArn]])
            .responseJSON(completionHandler: findingFetched)
    }

    func findingFetched(response: DataResponse<Any>) {
        hideIndicator()
        guard let json = response.result.value as? [String: AnyObject],
            let findingsJSON = json["findings"] as? [[String:AnyObject]]
            else {
                showSimpleAlertWithTitle(message: "Unable to fetch finding.", viewController: self)
                return
        }

        let findings = Finding.parseJSONToArray(findingsJSON)
        guard !findings.isEmpty else {
            showSimpleAlertWithTitle(message: "Unable to deserialize findings.", viewController: self)
            return
        }

        let finding = findings[0]
        self.finding = finding
        attributes = finding.attributes
        userAttributes = finding.userAttributes

        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case FindingDetailsTableViewController.DETAILS_SECTION:
            return 13
        case FindingDetailsTableViewController.ATTRIBUTES_SECTION:
            return attributes.count
        case FindingDetailsTableViewController.USER_ATTRIBUTES_SECTION:
            return userAttributes.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)

        if indexPath.section == FindingDetailsTableViewController.DETAILS_SECTION {
            cell.textLabel?.text = title(for: indexPath.row)
            cell.detailTextLabel?.text = subtitle(for: indexPath.row)
        }
        else if indexPath.section == FindingDetailsTableViewController.ATTRIBUTES_SECTION {
            let ss = attributes[indexPath.row]
            cell.textLabel?.text = ss.value
            cell.detailTextLabel?.text = ss.key
        }
        else {
            let ss = userAttributes[indexPath.row]
            cell.textLabel?.text = ss.value
            cell.detailTextLabel?.text = ss.key
        }

        return cell
    }

    func subtitle(for row: Int) -> String? {
        switch row {
        case 0:
            return "Finding arn"
        case 1:
            return "Asset type"
        case 2:
            return "Confidence"
        case 3:
            return "Created at"
        case 4:
            return "Description"
        case 5:
            return "Id"
        case 6:
            return "Numeric severity"
        case 7:
            return "Recommendation"
        case 8:
            return "Schema version"
        case 9:
            return "Service"
        case 10:
            return "Severity"
        case 11:
            return "Title"
        case 12:
            return "Updated at"
        default:
            return nil
        }
    }

    func title(for row: Int) -> String? {
        guard let finding = finding else {
            return nil
        }

        switch row {
        case 0:
            return finding.arn
        case 1:
            return finding.assetType
        case 2:
            return finding.confidence != nil ? "\(finding.confidence!)" : nil
        case 3:
            return MediumDateFormatter.format(finding.createdAt)
        case 4:
            return finding.description
        case 5:
            return finding.id
        case 6:
            return finding.numericSeverity != nil ? "\(finding.numericSeverity!)" : nil
        case 7:
            return finding.recommendation
        case 8:
            return finding.schemaVersion != nil ? "\(finding.schemaVersion!)" : nil
        case 9:
            return finding.service
        case 10:
            return finding.severity
        case 11:
            return finding.title
        case 12:
            return MediumDateFormatter.format(finding.updatedAt)
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case FindingDetailsTableViewController.DETAILS_SECTION:
            return "Details"
        case FindingDetailsTableViewController.ATTRIBUTES_SECTION:
            return "Attributes"
        case FindingDetailsTableViewController.USER_ATTRIBUTES_SECTION:
            return "User Attributes"
        default:
            return nil
        }
    }

}
