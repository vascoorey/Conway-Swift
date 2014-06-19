//
//  Conway.swift
//  Conway
//
//  Created by Vasco d'Orey on 04/06/14.
//  Copyright (c) 2014 Delta Dog. All rights reserved.
//

import Foundation

struct SetGenerator<T> : Generator {
  typealias Element = T
  
  var items: Slice<Element>
  
  init(items: Slice<Element>) {
    self.items = items
  }
  
  mutating func next() -> Element?  {
    if items.isEmpty {
      return nil
    }
    let ret = items[0]
    items = items[1..items.count]
    return ret
  }
  
  var hasNext: Bool {
  return !items.isEmpty
  }
}

struct Set<T: Hashable> : Printable {
  typealias Element = T
  
  var items = Dictionary<T, T>()
  
  var count: Int {
  return items.count
  }
  
  mutating func append(item: Element) {
    items[item] = item
  }
  
  mutating func remove(item: Element) {
    items[item] = nil
  }
  
  var description: String {
  var desc = "<"
  var generator = self.generate()
  while let next = generator.next() {
    desc += "\(next)"
    if generator.hasNext {
      desc += ", "
    }
  }
  return desc + ">"
  }
}

extension Set: Sequence {
  func generate() -> SetGenerator<Element> {
    let keys = Array(items.keys)
    return SetGenerator(items: keys[0..keys.count])
  }
}

struct Point {
  var row, column: Int
}

struct Size {
  var rows, columns: Int
}

protocol ConwayDelegate {
  func conway(gameOfLife: Conway, cellsDidActivateAtPoints points: Array<Point>)
  func conway(gameOfLife: Conway, cellsDidDieAtPoinst points: Array<Point>)
}

class Conway : Printable {
  var grid: Bool[]
  var counts: Int[]
  var changes: Set<Int>
  var delegate: ConwayDelegate?
  
  var size: Size {
  willSet {
    grid = Array<Bool>(count: newValue.rows * newValue.columns, repeatedValue: false)
  }
  }
  
  init(rows: Int, columns: Int) {
    self.size = Size(rows: rows, columns: columns)
    grid = Bool[](count: rows * columns, repeatedValue: false)
    counts = Int[](count: rows * columns, repeatedValue: 0)
    changes = Set<Int>()
  }

  func flipStateAtPoint(row: Int, column: Int) {
    assert(row >= 0 && row < size.rows && column >= 0 && column < size.columns)
    
    let index = row * size.columns + column
    let newValue = !grid[index]
    grid[index] = newValue
    updateNeighborCounts(neighbors(index, row:row, column:column), adding: newValue)
  }
  
  func flipStateAtIndex(index: Int) {
    let newValue = !grid[index]
    
//    if newValue {
//      changes.append(index)
//    } else {
//      changes.remove(index)
//    }
    
    grid[index] = newValue
    let row = index / size.columns
    let column = index % size.columns
    updateNeighborCounts(neighbors(index, row:row, column:column), adding: newValue)
  }
  
  func neighbors(index: Int, row: Int, column: Int) -> Int[] {
    var neighbors = Array<Int>(count: 8, repeatedValue: 0)

    // Wrap around if row = 0 || row = size.rows - 1
    // Or column = 0 || column = size.columns - 1
    let previousRow = row == 0 ? size.rows - 1 : row - 1
    let nextRow = row == (size.rows - 1) ? 0 : row + 1
    let previousColumn = column == 0 ? size.columns - 1 : column - 1
    let nextColumn = column == (size.columns - 1) ? 0 : column + 1

    neighbors[0] = previousRow * size.columns + previousColumn
    neighbors[1] = previousRow * size.columns + column
    neighbors[2] = previousRow * size.columns + nextColumn
    neighbors[3] = row * size.columns + previousColumn
    neighbors[4] = row * size.columns + nextColumn
    neighbors[5] = nextRow * size.columns + previousColumn
    neighbors[6] = nextRow * size.columns + column
    neighbors[7] = nextRow * size.columns + nextColumn
    
    return neighbors
  }

  func updateNeighborCounts(indices: Int[], adding: Bool) {
    for i in indices {
//      changes.append(i)
      let count = counts[i]
      if adding {
        counts[i] = count + 1
      } else {
        if count > 0 {
          counts[i] = count - 1
        }
//        if count == 0 && !grid[i] {
//          changes.remove(i)
//        }
      }
    }
  }

  func tick() {
    let then = CFAbsoluteTimeGetCurrent()
    var aliveQueue = Int[]()
    var deadQueue = Int[]()
    
    for index in 0..grid.count {
      let value = grid[index]
      let count = counts[index]
      if value {
        if count < 2 || count > 3 {
          deadQueue.append(index)
        }
      } else {
        if count == 3 {
          aliveQueue.append(index)
        }
      }
    }
    
    for i in deadQueue + aliveQueue {
      flipStateAtIndex(i)
    }
    println("Tick took: \(CFAbsoluteTimeGetCurrent() - then) seconds.")
//    println(self.descriptionWithNeighborCounts)
  }
  
  var description: String {
  get {
    var description = ""
    
    for row in 0..size.rows {
      for column in 0..size.columns {
        let idx = row * size.columns + column
        if grid[idx] {
          description += "o "
        } else {
          description += ". "
        }
      }
      description += "\n"
    }
    
    return description
  }
  }
  
  var descriptionWithNeighborCounts: String {
  get {
    var description = ""
    
    for row in 0..size.rows {
      for column in 0..size.columns {
        let idx = row * size.columns + column
        if grid[idx] {
          description += "o "
        } else {
          description += ". "
        }
      }
      description += " | "
      for column in 0..size.columns {
        let idx = row * size.columns + column
        let count = counts[idx]
        if count > 0 {
          description += "\(count) "
        } else {
          description += ". "
        }
      }
      description += "\n"
    }
    
    return description
  }
  }
}
