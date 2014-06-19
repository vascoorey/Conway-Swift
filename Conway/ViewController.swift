//
//  ViewController.swift
//  Conway
//
//  Created by Vasco d'Orey on 04/06/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @lazy var conway = Conway(rows: 32, columns: 24)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

