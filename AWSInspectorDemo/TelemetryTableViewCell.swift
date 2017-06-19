//
//  TelemetryTableViewCell.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/19/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit

class TelemetryTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var dataSizeLabel: UILabel!
    @IBOutlet weak var messageTypeLabel: UILabel!

    var telemetry: Telemetry? {
        didSet {
            if let telemetry = telemetry {
                countLabel.text = "Count: \(telemetry.count)"
                messageTypeLabel.text = "Message type: \(telemetry.messageType)"
                dataSizeLabel.text = telemetry.dataSize == nil ? "No data size." : "Data size: \(telemetry.dataSize!)"
            }
        }
    }
    
}
