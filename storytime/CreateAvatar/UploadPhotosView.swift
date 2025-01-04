//
//  UploadPhotosView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import PhotosUI
import SwiftUI

extension UploadPhotosView {
  enum UploadPhotosState {
    case stepOne
    case stepTwo

    var actionButtonText: String {
      switch self {
      case .stepOne:
        return "Continue"
      case .stepTwo:
        return "Upload 1-2 selfies"
      }
    }

    var guidelinesText: String {
      switch self {
      case .stepOne:
        return "Photo guidelines - what to use"
      case .stepTwo:
        return "Photo guidelines - what not to use"
      }
    }

    var imageColor: Color {
      switch self {
      case .stepOne:
        return .green
      case .stepTwo:
        return .red
      }
    }

    var imageName: String {
      switch self {
      case .stepOne:
        return "checkmark"
      case .stepTwo:
        return "xmark"
      }
    }

    var requirementsText: String {
      switch self {
      case .stepOne:
        return
"""
\u{2022} Selfies or photos of you with your full face.
\u{2022} Photos with good lighting and focus.
\u{2022} A variety of angles and backgrounds.
\u{2022} Different facial expressions.
"""
      case .stepTwo:
        return
"""
\u{2022} No photos of children.
\u{2022} No photos of any kind of nudity.
\u{2022} Avoid full body shots with extreme close-ups.
\u{2022} Avoic black and white photos.
"""
      }
    }
  }
}

struct ImageContainer: Identifiable, Hashable {
  let id = UUID().uuidString
  let image: Image

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

struct UploadPhotosView: View {
  private static let CONTAINER_SIZE = CGSize(width: 200, height: 200)
  private static let IMAGE_SIZE = CGSize(width: 400, height: 400)

  let completion: () -> Void

  init(_ completion: @escaping () -> Void) {
    self.completion = completion
  }

  @State var state = UploadPhotosState.stepOne
  @State var selectedItems = [PhotosPickerItem]()
  @State var imageContainers = [ImageContainer]()

  var body: some View {
    VStack {
      Spacer()

      VStack {
        Text("STEP 1")
          .font(.headline)

        Text("Upload your photos")
          .font(.title2)
          .fontWeight(.bold)
          .padding(.bottom)

        Text("StoryTime does not keep any copies of your photos. All photos that you upload are immediately deleted after StoryTime's servers once your AI digital twin is created.")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .padding()
      .padding(.horizontal)

      Text(state.guidelinesText)
        .fontWeight(.semibold)

      ScrollView(.horizontal) {
        HStack {
          ForEach(MOCK_DATA.profileImageNames, id: \.self) { imageName in
            VStack(spacing: 0) {
              Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Self.IMAGE_SIZE.width, height: Self.IMAGE_SIZE.height)
            }
            .frame(width: Self.CONTAINER_SIZE.width, height: Self.CONTAINER_SIZE.height)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(alignment: .init(horizontal: .trailing, vertical: .bottom)) {
              VStack {
                Image(systemName: state.imageName)
                  .resizable()
                  .frame(width: 15, height: 15)
                  .foregroundStyle(.white)
              }
              .frame(width: 30, height: 30)
              .background(state.imageColor)
              .clipShape(Circle())
              .padding()
            }
          }
        }
        .padding(.leading)
      }
      .scrollIndicators(.never)
      .frame(alignment: .center)

      VStack(alignment: .leading) {
        Text("Requirements:")
          .font(.headline)
        Text(.init(state.requirementsText))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()

      Spacer()

      if !imageContainers.isEmpty {
        Text("Selected \(imageContainers.count)/2 images.")
        HStack {
          ForEach(imageContainers, id: \.self) { imageContainer in
            imageContainer.image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              .overlay(alignment: .init(horizontal: .leading, vertical: .top)) {
                Button {
                  Task {
                    guard
                      let index = (imageContainers.firstIndex {
                        $0.id == imageContainer.id
                      }),
                      index > -1,
                      index < imageContainers.count,
                      index < selectedItems.count
                    else { return }
                    imageContainers.remove(at: index)
                    selectedItems.remove(at: index)
                  }
                } label: {
                  Image(systemName: "trash")
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 15, height: 15)
                    .padding(5)
                    .background(.red)
                    .clipShape(Circle())
                    .padding(5)
                }
              }
          }
        }
      }

      VStack {
        Button {
          withAnimation {
            state = .stepTwo
          }
        } label: {
          switch state {
          case .stepOne:
            Text(state.actionButtonText)
              .foregroundStyle(.white)
              .font(.system(size: 20, weight: .bold))
              .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
              .background(.black)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          case .stepTwo:
              PhotosPicker(selection: $selectedItems, maxSelectionCount: 2, matching: .images) {
                Text(state.actionButtonText)
                  .foregroundStyle(.white)
                  .font(.system(size: 20, weight: .bold))
                  .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                  .background(.black)
                  .clipShape(RoundedRectangle(cornerRadius: 8))
              }
              .foregroundStyle(.white)
              .onChange(of: selectedItems) { oldValue, newValue in
                selectedItemsOnChange(oldValue, newValue)
              }
          }
        }

        if !imageContainers.isEmpty {
          Button {
            completion()
          } label: {
            Text("Next")
              .foregroundStyle(.white)
              .font(.system(size: 20, weight: .bold))
              .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
              .background(.blue)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
        }
      }
      .padding()
    }
  }

  private func selectedItemsOnChange(
    _ oldValue: [PhotosPickerItem],
    _ newValue: [PhotosPickerItem]
  ) {
    guard oldValue != newValue else { return }
    imageContainers.removeAll()

    Task {
      for item in selectedItems {
        item.loadTransferable(type: Image.self) { result in
          switch result {
          case .success(let success):
            if let image = success {
              imageContainers.append(.init(image: image))
            }
          case .failure(let failure):
            print("Could not convert PhotosPickerItem to an Image: \(failure.localizedDescription)")
          }
        }
      }
    }
  }
}

#Preview {
  UploadPhotosView {}
}
