//
//  StorytimeCategory.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import Foundation

enum StorytimeCategory: String, CaseIterable, StorytimeScrollablePickerViewData {
  case all
  case stories
  case puzzles
  case sleep
  case homework
  case music

  var id: Self { self }

  var description: String {
    switch self {
    case .all, .stories, .puzzles,
        .homework, .music:
      return rawValue.capitalized
    case .sleep:
      return "Sleep"
    }
  }
}
