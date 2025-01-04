//
//  UploadVoiceView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import SwiftUI

struct UploadVoiceView: View {
  private static let CONTAINER_SIZE = CGSize(width: 200, height: 200)
  private static let IMAGE_SIZE = CGSize(width: 400, height: 400)

  let completion: () -> Void

  @State var isFileChooserPresented = false
  @State var selectedFile: URL?

  init(_ completion: @escaping () -> Void) {
    self.completion = completion
  }

  var body: some View {
    VStack {
      Spacer()

      VStack {
        Text("STEP 2")
          .font(.headline)

        Text("Add your voice")
          .font(.title2)
          .fontWeight(.bold)
          .padding(.bottom)

        Text("Upload 3-60 seconds of audio to your voice or record directly from the app.")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .padding()
      .padding(.horizontal)

      Spacer()

      if let file = selectedFile {
        VStack {
          Text("Files uploaded")
            .font(.title)
            .fontWeight(.bold)

          Text(file.absoluteString)
            .font(.caption)
        }
      }

      VStack {
        Button {
          isFileChooserPresented = true
        } label: {
          Text("Upload a file")
            .foregroundStyle(.white)
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .fileImporter(
          isPresented: $isFileChooserPresented,
          allowedContentTypes: [.audio]
        ) { result in
          switch result {
          case .success(let success):
            self.selectedFile = success
          case .failure(let failure):
            // TODO: Implement failure state.
            print("Failed to choose audio file: \(failure.localizedDescription).")
            break
          }
        }

        if selectedFile != nil {
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
}

#Preview {
  UploadVoiceView {}
}
