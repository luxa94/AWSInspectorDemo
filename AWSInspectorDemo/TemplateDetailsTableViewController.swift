//
//  TemplateDetailsTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit
import Alamofire

class TemplateDetailsTableViewController: IndicatorTableViewController {

    @IBOutlet weak var startRunButton: UIBarButtonItem!

    private static let DETAILS_SECTION = 0
    private static let RULE_ARNS_SECTION = 1
    private static let USER_ATTRIBUTES_SECTION = 2

    private static let ARNS_PROPERTY = "assessmentTemplateArns"

    var templateArn: String?
    var template: AssessmentTemplate?
    let requestProcessor = RequestProcessor()

    var rulePackageArns: [String] = []
    var userAttributesForFindings: [UserAttributeForFindings] = []

    override func viewDidLoad() {
        tableView.register(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: "BasicCell")
        tableView.register(UINib(nibName: "SubtitleCell", bundle: nil), forCellReuseIdentifier: "SubtitleCell")

        tableView.estimatedRowHeight = 60
    }

    override func viewWillAppear(_ animated: Bool) {
        if let arn = templateArn {
            showIndicator()
            fetchTemplateDetails(arn: arn)
        }
    }

    func fetchTemplateDetails(arn: String) {
        let parameters = Arns(jsonName: TemplateDetailsTableViewController.ARNS_PROPERTY, arns: [arn])
        requestProcessor.sendRequest(request: .describeAssessmentTemplates, parameters: parameters.toJSONDictionary())
            .responseJSON(completionHandler: templateDetailsFetched)
    }

    func templateDetailsFetched(response: DataResponse<Any>) {
        hideIndicator()
        guard let json = response.result.value as? [String: AnyObject],
            let templatesJSON = json["assessmentTemplates"] as? [[String: AnyObject]]
            else {
                showSimpleAlertWithTitle(message: "Unable to fetch selected template.", viewController: self)
                return
        }

        let templates = AssessmentTemplate.parseJSONToArray(templatesJSON)
        guard !templates.isEmpty else {
            showSimpleAlertWithTitle(message: "Unable to deserialize selected template.", viewController: self)
            return
        }

        let template = templates[0]
        self.template = template
        rulePackageArns = template.rulesPackageArns
        userAttributesForFindings = template.userAttributesForFindings

        startRunButton.isEnabled = true

        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TemplateDetailsTableViewController.DETAILS_SECTION:
            return template != nil ? 5 : 0
        case TemplateDetailsTableViewController.RULE_ARNS_SECTION:
            return rulePackageArns.count
        case TemplateDetailsTableViewController.USER_ATTRIBUTES_SECTION:
            return userAttributesForFindings.count
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TemplateDetailsTableViewController.RULE_ARNS_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

            let packageArn = rulePackageArns[indexPath.row]
            cell.textLabel?.text = packageArn

            return cell
        }
        else if indexPath.section == TemplateDetailsTableViewController.USER_ATTRIBUTES_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)

            let userAttribute = userAttributesForFindings[indexPath.row]
            cell.textLabel?.text = userAttribute.key
            cell.detailTextLabel?.text = userAttribute.value

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath)

            let row = indexPath.row
            cell.textLabel?.text = title(for: row)
            cell.detailTextLabel?.text = subtitle(for: row)

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case TemplateDetailsTableViewController.DETAILS_SECTION:
            return "Details"
        case TemplateDetailsTableViewController.RULE_ARNS_SECTION:
            return "Rule package arns"
        case TemplateDetailsTableViewController.USER_ATTRIBUTES_SECTION:
            return "User attributes for findings"
        default:
            return nil
        }
    }

    func subtitle(for row: Int) -> String? {
        switch row {
        case 0:
            return "Template arn"
        case 1:
            return "Template name"
        case 2:
            return "Target arn"
        case 3:
            return "Created at"
        case 4:
            return "Duration in seconds"
        default:
            return nil
        }
    }

    func title(for row: Int) -> String? {
        guard let template = template else {
            return nil
        }

        switch row {
        case 0:
            return template.arn
        case 1:
            return template.name
        case 2:
            return template.assessmentTargetArn
        case 3:
            return MediumDateFormatter.format(template.createdAt)
        case 4:
            return "\(template.durationInSeconds)"
        default:
            return nil
        }
    }

    @IBAction func startRun(_ sender: Any) {
        guard let arn = templateArn else {
            showSimpleAlertWithTitle(message: "Unable to send run request.", viewController: self)
            return
        }

        let parameters = ["assessmentTemplateArn": arn]
        requestProcessor.sendRequest(request: .startAssessmentRun, parameters: parameters)
            .responseJSON(completionHandler: startRunHandler)
    }

    func startRunHandler(response: DataResponse<Any>) {
        guard let json = response.result.value as? [String: AnyObject],
            let runArn = json["assessmentRunArn"] as? String
            else {
                showSimpleAlertWithTitle(message: "Unable to start run.", viewController: self)
                return
        }

        showSimpleAlertWithTitle(message: "Run with arn \(runArn) started.", viewController: self)
    }

}
