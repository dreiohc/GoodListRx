//
//  Task.swift
//  GoodList
//
//  Created by Myron Dulay on 4/15/21.
//

import Foundation

enum Priority: Int {
  case high
  case medium
  case low
}

struct Task {
  let title: String
  let priority: Priority
  
}
