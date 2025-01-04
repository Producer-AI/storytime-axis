//
//  AvatarAndTextView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import SwiftUI

struct AvatarAndTextView: View {
  private static let CONTAINER_SIZE = CGSize(width: 200, height: 200)
  private static let IMAGE_SIZE = CGSize(width: 400, height: 400)

  // TODO: Add author name
  let imageName: String
  @State var isLiked = false
  let numberOfLikes: String

  init(imageName: String, isLiked: Bool = false) {
    self.imageName = imageName
    self.isLiked = isLiked
    let likesCount = Double((10_000...100_000).randomElement() ?? 40_000)
    self.numberOfLikes = String(format: "%.1fk", likesCount / 1000)
  }

  var body: some View {
    VStack {
      VStack(spacing: 0) {
        Image(imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: Self.IMAGE_SIZE.width, height: Self.IMAGE_SIZE.height)
      }
      .frame(width: Self.CONTAINER_SIZE.width, height: Self.CONTAINER_SIZE.height)
      .clipShape(RoundedRectangle(cornerRadius: 10))

      Text(imageName.capitalized)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)

      HStack(spacing: 5) {
        Image(systemName: isLiked ? "heart.fill" : "heart")
          .foregroundStyle(isLiked ? .red : .black)
        Text(numberOfLikes)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .onTapGesture {
        withAnimation {
          isLiked.toggle()
        }
      }
    }
  }
}

#Preview {
  ScrollView(.horizontal) {
    HStack {
      ForEach(MOCK_DATA.bookTitles, id: \.self) { imageName in
        AvatarAndTextView(imageName: imageName)
      }
    }
    .padding(.horizontal)
  }
  .scrollIndicators(.hidden)
}
