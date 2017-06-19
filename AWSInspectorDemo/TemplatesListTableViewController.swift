//
//  TemplatesListTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/18/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit
import Alamofire

class TemplatesListTableViewController: IndicatorTableViewController {

    private static let ARNS_PROPERTY = "assessmentTemplateArns"

    var arns: [String] = []
    var requestProcessor = RequestProcessor()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(fetchTemplates), for: UIControlEvents.valueChanged)
        self.view.addSubview(self.refreshControl!)
    }

    override func viewWillAppear(_ animated: Bool) {
        showIndicator()
        fetchTemplates()
    }

    func fetchTemplates() {
        requestProcessor.sendRequest(request: .listAssessmentTemplates)
            .responseJSON(completionHandler: templatesFetched)
    }

    func templatesFetched(response: DataResponse<Any>) {
        hideIndicator()
        guard let json = response.result.value as? [String: AnyObject],
            let arns = Arns.fromJSONDictionary(json, jsonName: TemplatesListTableViewController.ARNS_PROPERTY) else {
                print("fuck")
                reload([])
                return
        }

        reload(arns.arns)
    }

    func reload(_ arns: [String]) {
        self.arns = arns
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arns.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arnCell", for: indexPath)

        cell.textLabel?.text = arns[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTemplateDetails", sender: arns[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTemplateDetails" {
            if let vc = segue.destination as? TemplateDetailsTableViewController {
                vc.templateArn = sender as? String
            }
        }
    }

}
