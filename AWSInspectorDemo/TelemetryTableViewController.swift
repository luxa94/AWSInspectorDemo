//
//  TelemetryTableViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/19/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit
import Alamofire

class TelemetryTableViewController: IndicatorTableViewController {

    var runArn: String!
    let requesrProcessor = RequestProcessor()

    var telemetries: [Telemetry] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60

        tableView.register(UINib(nibName: "TelemetryTableViewCell", bundle: nil), forCellReuseIdentifier: "TelemetryTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        showIndicator()
        fetchTelemetry()
    }

    func fetchTelemetry() {
        requesrProcessor.sendRequest(request: .getTelemetryMetadata, parameters: ["assessmentRunArn": runArn])
            .responseJSON(completionHandler: telemetryFetched)
    }

    func telemetryFetched(response: DataResponse<Any>) {
        hideIndicator()
        guard let json = response.result.value as? [String: AnyObject],
            let telemetryJSON = json["telemetryMetadata"] as? [[String: AnyObject]]
            else {
                showSimpleAlertWithTitle(message: "Unable to fetch telemetry metadata.", viewController: self)
                return
        }

        telemetries = Telemetry.parseJSONToArray(telemetryJSON)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return telemetries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TelemetryTableViewCell", for: indexPath) as! TelemetryTableViewCell

        cell.telemetry = telemetries[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
