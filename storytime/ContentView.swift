//
//  ContentView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  //  @Environment(\.modelContext) private var modelContext
  //  @Query private var items: [Item]
  @State var selectedTab = StorytimeTab.avatarHome
  @State var isCreateAvatarViewPresented = false
  @State var isCreateStoryViewPresented = false

  var body: some View {
    ZStack(alignment: .init(horizontal: .center, vertical: .bottom)) {
      TabView(selection: $selectedTab) {
        ForEach(StorytimeTab.allCases, id: \.self) { tab in
          Tab(tab.title, systemImage: tab.imageName, value: tab) {
            viewForTab(tab)
          }
        }
      }
      .tint(.purple)

      Menu {
        Button {
          isCreateAvatarViewPresented = true
        } label: {
          Text("Create Avatar")
          Image(systemName: StorytimeTab.avatarHome.imageName)
        }

        Button {
          isCreateStoryViewPresented = true
        } label: {
          Text("Create Story")
          Image(systemName: StorytimeTab.bookHome.imageName)
        }
      } label: {
        Image(systemName: StorytimeTab.createAvatarOrStoryImageName)
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundStyle(.white)
          .padding()
          .background {
            Circle()
              .fill(.purple.gradient)
          }
      }
    }
    .sheet(isPresented: $isCreateAvatarViewPresented) {
      CreateAvatarView()
    }
    .sheet(isPresented: $isCreateStoryViewPresented) {
      CreateStoryView {}
    }
  }

  @ViewBuilder
  func viewForTab(_ tab: StorytimeTab) -> some View {
    switch tab {
    case .avatarHome:
      AvatarHomeView()
    case .bookHome:
      Color.clear
        .background {
          Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        }
    case .createAvatarOrStory:
      Color.clear
        .background {
          Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        }
    }
  }
}

#Preview {
  ContentView()
}
