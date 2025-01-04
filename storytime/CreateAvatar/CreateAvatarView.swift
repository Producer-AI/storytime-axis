//
//  CreateAvatarView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import PhotosUI
import SwiftUI

enum CreateAvatarViewStep: Int, CaseIterable, Hashable, Identifiable {
  case uploadPhotos
  case addVoice

  var id: Self { self }
}

struct CreateAvatarView: View {
  @Environment(\.dismiss) private var dismiss
  @State var path = [CreateAvatarViewStep]()

  private func progressStep() {
    guard let step = path.last else {
      path.append(.addVoice)
      return
    }

    switch step {
    case .uploadPhotos:
      path.append(.addVoice)
    case .addVoice:
      break
    }
  }

  var body: some View {
    NavigationStack(path: $path) {
      UploadPhotosView {
        progressStep()
      }
      .navigationDestination(for: CreateAvatarViewStep.self) { step in
        switch step {
        case .uploadPhotos:
          UploadPhotosView {
            progressStep()
          }
        case .addVoice:
            UploadVoiceView {
            // TODO: Implement.
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  CreateAvatarView()
}
