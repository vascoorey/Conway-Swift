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

struct Point {
  var row, column: Int
  
  init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }
}

protocol ConwayDelegate {
  func conway(gameOfLife: Conway, cellsDidActivateAtPoints points: Array<Point>)
  func conway(gameOfLife: Conway, cellsDidDieAtPoinst points: Array<Point>)
}

class Conway {
  var grid: Dictionary<Int, Dictionary<Int, Int>>
  var originRule = [3]
  var stayAliveRule = [2, 3]
  var delegate: ConwayDelegate?
  
  var neighborCounts: Dictionary<Int, Dictionary<Int, Int>> {
  get {
    var counts = Dictionary<Int, Dictionary<Int, Int>>()
    for (rowNumber, row) in grid {
      let previousRow = (rowNumber == 0) ? size.rows - 1 : rowNumber - 1
      let nextRow = (rowNumber == (size.rows - 1)) ? 0 : rowNumber + 1
      for (columnNumber, value) in row {
        let previousColumn = (columnNumber == 0) ? size.columns - 1 : columnNumber - 1
        let nextColumn = (columnNumber == (size.columns - 1)) ? 0 : columnNumber + 1
        
        counts[previousRow] = updateCounts(counts[previousRow], columns: [previousColumn, columnNumber, nextColumn])
        counts[nextRow] = updateCounts(counts[nextRow], columns: [previousColumn, columnNumber, nextColumn])
        // Current row is a special case
        var currentRow = updateCounts(counts[rowNumber], columns: [previousColumn, nextColumn])
        if !currentRow[columnNumber] {
          currentRow[columnNumber] = 0
        }
        counts[rowNumber] = currentRow
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
  }
  
  // Increment each column by 1
  func updateCounts(row: Dictionary<Int, Int>?, columns: Int[]) -> Dictionary<Int, Int> {
    var updatedCounts = row? ? row! : Dictionary<Int,Int>()
    for i in columns {
      if let count = updatedCounts[i] {
        updatedCounts[i] = count + 1
      } else {
        updatedCounts[i] = 1
      }
    }
    return updatedCounts
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
    var aliveQueue = Array<Point>()
    var deadQueue = Array<Point>()
    
    let neighborCounts = self.neighborCounts
    
    for (rowNumber, row) in neighborCounts {
      for (columnNumber, neighborCount) in row {
        if let value = grid[rowNumber]?[columnNumber]? {
          // A live cell stays alive if it's neighbor count is contained in the stayAliveRule array
          if !neighborCount.isIn(stayAliveRule) {
            aliveQueue.append(Point(row:rowNumber, column:columnNumber))
          }
        } else {
          // A dead cell comes to life if it's neighbor count is contained in the originRule
          if neighborCount.isIn(originRule) {
            deadQueue.append(Point(row:rowNumber, column:columnNumber))
          }
        }
      }
    }
    
    let flipQueue = aliveQueue + deadQueue
    for point in flipQueue {
      self.flipStateAtPoint(point.row, column: point.column)
    }
    
    delegate?.conway(self, cellsDidActivateAtPoints: aliveQueue)
    delegate?.conway(self, cellsDidDieAtPoinst: deadQueue)
    
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
        } else {
          description += ". "
        }
      }
      description += "\n"
    }
    
    return description
  }
}
