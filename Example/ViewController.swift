//
//  ViewController.swift
//  ExpandableInput
//
//  Created by Julien Colin on 5/1/15.
//  Copyright (c) 2015 Toldino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var expandableInputView: ExpandableInputView!
  override func viewDidLoad() {
    super.viewDidLoad()
    expandableInputView.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController: ExpandableInputDelegate {
  func sendAction() {
    println("Send action")
  }
}

