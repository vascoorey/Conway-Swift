//
//  ConwayView.swift
//  Conway
//
//  Created by Vasco d'Orey on 05/06/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

import UIKit

class ConwayView: UIView {
  var path: CGMutablePathRef
  var size: Size
  
  init(coder aDecoder: NSCoder!) {
    size = Size(rows: 0, columns: 0)
    path = CGPathCreateMutable()
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews()  {
    super.layoutSubviews()
  }
}
