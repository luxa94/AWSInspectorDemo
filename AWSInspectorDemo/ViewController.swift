//
//  ViewController.swift
//  AWSInspectorDemo
//
//  Created by Nikola Lukic on 6/12/17.
//  Copyright © 2017 Nikola Lukic. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    let requestProcessor: RequestProcessor = RequestProcessor()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sendRequest()
    }

    @IBAction func buttonClick(_ sender: Any) {
        sendRequest()
    }

    func sendRequest() {
       requestProcessor.sendRequest(request: .listAssessmentTemplates)
        .responseJSON { response in
            print(response.result.value)
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
//        .responseString(completionHandler: { response in
//            print("1", response.request?.allHTTPHeaderFields)  // original URL request
//            print("2", response.response) // HTTP URL response
//            print("3", response.data)     // server data
//            print("4", response.result)   // result of response serialization
//            print("5", response.result.value)
//

//            print("asd")
//        })

    }

}

