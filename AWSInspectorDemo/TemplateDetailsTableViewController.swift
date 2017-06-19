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

    private static let ARNS_PROPERTY = "assessmentTemplateArns"

    var templateArn: String?
    var template: AssessmentTemplate?
    let requestProcessor = RequestProcessor()

    var rulePackageArns: [String] = []
    var userAttributesForFindings: [UserAttributeForFindings] = []

    @IBOutlet weak var arnCell: UITableViewCell!
    @IBOutlet weak var templateNameCell: UITableViewCell!
    @IBOutlet weak var assessmentTagetCell: UITableViewCell!
    @IBOutlet weak var createdAtCell: UITableViewCell!
    @IBOutlet weak var durationCell: UITableViewCell!


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
                print("fuck")
                return
        }

        let templates = AssessmentTemplate.parseJSONToArray(templatesJSON)
        guard !templates.isEmpty else {
            print("empty fuck")
            return
        }

        let template = templates[0]
        self.template = template
        rulePackageArns = template.rulesPackageArns
        userAttributesForFindings = template.userAttributesForFindings

        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return template != nil ? 5 : 0
        case 1:
            return rulePackageArns.count
        case 2:
            return userAttributesForFindings.count
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

            let packageArn = rulePackageArns[indexPath.row]
            cell.textLabel?.text = packageArn

            return cell
        }
        else if indexPath.section == 1 {
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
        case 0:
            return "Details"
        case 1:
            return "Rule package arns"
        case 2:
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

}
