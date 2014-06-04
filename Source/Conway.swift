//
//  Conway.swift
//  Conway
//
//  Created by Vasco d'Orey on 04/06/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

import Foundation

extension Int {
  func isIn(a: Array<Int>) -> Bool {
    for member in a {
      if self == member {
        return true
      }
    }
    return false
  }
}

class Conway {
  struct Point {
    var row, column: Int
    
    init(row: Int, column: Int) {
      self.row = row
      self.column = column
    }
  }
  
  var grid: Dictionary<Int, Dictionary<Int, Int>>
  var zeroCounts: Dictionary<Int, Dictionary<Int, Int>>
  var originRule = [3]
  var stayAliveRule = [2, 3]
  
  var neighborCounts: Dictionary<Int, Dictionary<Int, Int>> {
  get {
    var counts = zeroCounts
    
    for (rowNumber, row) in grid {
      let previousRow = (rowNumber == 0) ? size.rows - 1 : rowNumber - 1
      let nextRow = (rowNumber == (size.rows - 1)) ? 0 : rowNumber + 1
      for (columnNumber, value) in row {
        if(value == 1) {
          let previousColumn = (columnNumber == 0) ? size.columns - 1 : columnNumber - 1
          let nextColumn = (columnNumber == (size.columns - 1)) ? 0 : columnNumber + 1
          
          var previousRowCounts = counts[previousRow]!
          previousRowCounts[previousColumn] = previousRowCounts[previousColumn]! + 1
          previousRowCounts[columnNumber] = previousRowCounts[columnNumber]! + 1
          previousRowCounts[nextColumn] = previousRowCounts[nextColumn]! + 1
          counts[previousRow] = previousRowCounts
          
          var currentRowCounts = counts[rowNumber]!
          currentRowCounts[previousColumn] = currentRowCounts[previousColumn]! + 1
          currentRowCounts[nextColumn] = currentRowCounts[nextColumn]! + 1
          counts[rowNumber] = currentRowCounts
          
          var nextRowCounts = counts[nextRow]!
          nextRowCounts[previousColumn] = nextRowCounts[previousColumn]! + 1
          nextRowCounts[columnNumber] = nextRowCounts[columnNumber]! + 1
          nextRowCounts[nextColumn] = nextRowCounts[nextColumn]! + 1
          counts[nextRow] = nextRowCounts
        }
      }
    }
    
    return counts
  }
  }
  
  var size: (rows: Int, columns: Int) {
  willSet {
    grid = Dictionary<Int, Dictionary<Int, Int>>(minimumCapacity: newValue.rows)
  }
  }
  
  init(rows: Int, columns: Int) {
    self.size = (rows, columns)
    grid = Dictionary<Int, Dictionary<Int, Int>>(minimumCapacity: rows)
    zeroCounts = Dictionary<Int, Dictionary<Int, Int>>(minimumCapacity: rows)
    for r in 0..size.rows {
      var row = Dictionary<Int, Int>()
      for c in 0..size.columns {
        row[c] = 0
      }
      zeroCounts[r] = row
    }
  }
  
  func flipStateAtPoint(row: Int, column: Int) {
    assert(row >= 0 && row < size.rows && column >= 0 && column < size.columns)
    
    if var currentRow = grid[row] {
      if currentRow[column] {
        currentRow[column] = nil
      } else {
        currentRow[column] = 1
      }
      grid[row] = currentRow
    } else {
      var currentRow = Dictionary<Int, Int>()
      currentRow[column] = 1
      grid[row] = currentRow
    }
  }
  
  func tick() {
    let then = CFAbsoluteTimeGetCurrent()
    var flipQueue = Array<Point>()
    
    let neighborCounts = self.neighborCounts
    
    for (rowNumber, row) in neighborCounts {
      for (columnNumber, neighborCount) in row {
        if let value = grid[rowNumber]?[columnNumber]? {
          // A live cell stays alive if it's neighbor count is contained in the stayAliveRule array
          if !neighborCount.isIn(stayAliveRule) {
            flipQueue.append(Point(row:rowNumber, column:columnNumber))
          }
        } else {
          // A dead cell comes to life if it's neighbor count is contained in the originRule
          if neighborCount.isIn(originRule) {
            flipQueue.append(Point(row:rowNumber, column:columnNumber))
          }
        }
      }
    }
    
    for point in flipQueue {
      self.flipStateAtPoint(point.row, column: point.column)
    }
    
    println("Tick took: \(CFAbsoluteTimeGetCurrent() - then) seconds.")
    println(self.descriptionWithNeighborCounts())
  }
  
  func description() -> String {
    var description = ""
    
    for row in 0..size.rows {
      for column in 0..size.columns {
        if grid[row]?[column] {
          description += "o "
        } else {
          description += ". "
        }
      }
      description += "\n"
    }
    
    return description
  }
  
  func descriptionWithNeighborCounts() -> String {
    var description = ""
    var neighborCounts = self.neighborCounts
    
    for row in 0..size.rows {
      for column in 0..size.columns {
        if grid[row]?[column] {
          description += "o "
        } else {
          description += ". "
        }
      }
      description += " | "
      for column in 0..size.columns {
        if let value = neighborCounts[row]?[column]? {
          description += "\(value) "
        }
      }
      description += "\n"
    }
    
    return description
  }
}
