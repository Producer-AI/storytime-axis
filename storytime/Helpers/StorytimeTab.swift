//
//  StorytimeTab.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import Foundation

enum StorytimeTab: String, CaseIterable, Identifiable, Hashable {
  case avatarHome
  case createAvatarOrStory
  case bookHome

  var id: Self { self }

  static var createAvatarOrStoryImageName: String {
    "plus"
  }

  var imageName: String {
    switch self {
    case .avatarHome:
      return "person.crop.circle"
    case .bookHome:
      return "books.vertical"
    case .createAvatarOrStory:
      return ""
    }
  }

  var title: String {
    switch self {
    case .avatarHome:
      return "Avatars"
    case .bookHome:
      return "Books"
    case .createAvatarOrStory:
      return ""
    }
  }
}
