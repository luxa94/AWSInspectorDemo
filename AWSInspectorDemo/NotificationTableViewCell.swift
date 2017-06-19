//
//  NotificationTableViewCell.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/19/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var snsTopicActionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var notification: AssessmentRunNotification? {
        didSet {
            if let notification = notification {
                dateLabel.text = MediumDateFormatter.format(notification.date)
                errorLabel.text = notification.error ? "ERROR" : "No error"
                eventLabel.text = notification.event
                snsTopicActionLabel.text = notification.snsTopicArn
                messageLabel.text = notification.message
            }
        }
    }

}
