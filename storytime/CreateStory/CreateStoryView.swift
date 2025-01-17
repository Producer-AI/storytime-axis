//
//  CreateStoryView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import SwiftUI
import FirebaseFirestore

struct CreateStoryView: View {
  let db = Firestore.firestore()
  let completion: () -> Void

  @State var storyTitle = ""
  @State var storyBody = ""

  init(_ completion: @escaping () -> Void) {
    self.completion = completion
  }

  func saveStory() {
    db.collection("personalities").addDocument(data: [
      "category": "story_time",
      "name": storyTitle,
      "subtitle": "User's name",
      "transcript": storyBody,
      "createdAt": Date(),
      "updatedAt": Date(),
    ]) {
      error in
      if let error = error {
        print("Error saving story: \(error)")
      } else {
        print("Story saved successfully")
        completion()
      }
    }
  }

  var body: some View {
    VStack {
      VStack {
        Text("Create your own story!")
          .font(.title2)
          .fontWeight(.bold)
          .padding(.bottom)

        Text("Whether it's a magical fairy tale you've made up or a special memory from your own life!")
          .font(.caption)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
      }
      .padding()
      .padding(.horizontal)

      Text("What's the title of your story?")
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    
      TextField("", text: $storyTitle)
        .background(.gray.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
        .frame(height: 20)
        .padding()
        .padding(.horizontal)

      Text("Write your story here! Or use AI to help you create one.")
        .font(.caption)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)

      TextEditor(text: $storyBody)
        .scrollContentBackground(.hidden)
        .background(.gray.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
        .frame(height: 350)
        .padding()
        .padding(.horizontal)

      HStack {
        Button {
          storyBody = "Hardcoded sample text.\n\n**TODO:** Replace with actual AI service. "
        } label: {
          HStack {
            Text("Create with AI")
              .foregroundStyle(.black)
              .font(.system(size: 20, weight: .bold))
            Text(Image(systemName: "sparkles"))
              .foregroundStyle(.yellow)
          }
          .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
          .background(LinearGradient.blue)
          .contentShape(RoundedRectangle(cornerRadius: 8))
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }

        Button {
          saveStory()
        } label: {
          Text("Submit")
            .foregroundStyle(.black)
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .background(storyBody.isEmpty ? Color.axisPurple.opacity(0.5) : Color.axisPurple)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(storyBody.isEmpty)
      }
      .padding()
    }
  }
}

#Preview {
  CreateStoryView {}
}

extension Color {
  static var axisPurple: Color {
    Color(uiColor: .init(red: 211/255, green: 171/255, blue: 251/255, alpha: 1))
  }
}

extension LinearGradient {
  static var blue: LinearGradient {
    .init(
      colors: [
        Color(uiColor: .init(red: 193/255, green: 250/255, blue: 215/255, alpha: 1)),
        Color(uiColor: .init(red: 141/255, green: 180/255, blue: 248/255, alpha: 1)),
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }
}