//
//  AvatarHomeView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import SwiftUI

struct AvatarHomeView: View {
  @State var isSearchPresented = false
  @State var navigationPath = NavigationPath()
  @State var searchText = ""
  @State var selectedCategories: Set<StorytimeCategory> = [.all]
  @State var isCreateAvatarViewPresented = false
  @State var isCreateStoryViewPresented: Bool = false

  var body: some View {
    NavigationStack(path: $navigationPath) {
      List {
        Section {
          VStack {
            HStack {
              Text("Hi Amanda!")
                .frame(height: 40)
                .font(.system(size: 40, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.5)

              if isSearchPresented {
                TextField("Search", text: $searchText)
                  .frame(width: 150)
                  .padding(.horizontal)
                  .padding(.vertical, 5)
                  .transition(.scale.combined(with: .opacity).combined(with: .blurReplace))
                  .overlay {
                    RoundedRectangle(cornerRadius: 24)
                      .stroke(lineWidth: 0.5)
                  }
              } else {
                Spacer(minLength: 150)
              }

              HStack {
                Image(systemName: "magnifyingglass")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 30, height: 30)
                  .onTapGesture {
                    withAnimation {
                      isSearchPresented.toggle()
                    }
                  }

                Image(systemName: "person.crop.circle")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 30, height: 30)
                  .onTapGesture {
                    // TODO: Take user to profile screen (needs to be created).
                  }
              }
            }
            .padding(.horizontal)

            StorytimeScrollablePickerView(
              allItems: StorytimeCategory.allCases,
              selectedItems: $selectedCategories,
              isSingleSelection: true
            )
          }
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)

        Section {
          HStack {
            Text("Favorites")
            Spacer()
            HStack {
              Text("See all")
              Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
              // TODO: Implement see all screen.
            }
          }
          .fontWeight(.bold)
          .padding(.horizontal)

          ScrollView(.horizontal) {
            HStack {
              ForEach(MOCK_DATA.favoriteTitles, id: \.self) { imageName in
                NavigationLink {
                  StoryPlayerView(imageName: imageName)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                } label: {
                  AvatarAndTextView(imageName: imageName)
                }
                .foregroundStyle(.black)
              }
            }
            .padding(.horizontal)
          }
          .scrollIndicators(.hidden)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())

        Section {
          HStack {
            Text("Classic stories")
            Spacer()
            HStack {
              Text("See all")
              Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
              // TODO: Implement see all screen.
            }
          }
          .fontWeight(.bold)
          .padding(.horizontal)

            ScrollView(.horizontal) {
              HStack {
                ForEach(MOCK_DATA.bookTitles, id: \.self) { imageName in
                  NavigationLink {
                    StoryPlayerView(imageName: imageName)
                      .frame(maxWidth: .infinity, maxHeight: .infinity)
                      .aspectRatio(contentMode: .fit)
                      .ignoresSafeArea()
                  } label: {
                    AvatarAndTextView(imageName: imageName)
                  }
                  .foregroundStyle(.black)
                }
              }
            .padding(.horizontal)
          }
          .scrollIndicators(.hidden)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())

        // Current: Goes through create avatar flow
        // To be: Goes through create own story flow
        // TODO: Need to add a CreateOwnStoryView
        Section {
          HStack {
            HStack {
              Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 50, height: 50)

              Text("Create Your Own Story")
                .font(.title)
                .lineLimit(1)
                .fontWeight(.bold)
                .minimumScaleFactor(0.8)
            }
            .padding()
            .padding()
          }
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .frame(height: 140)
          .background(.purple.gradient)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          .padding()
          .onTapGesture {
            isCreateStoryViewPresented = true
          }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
      }
      .listStyle(.plain)
      .sheet(isPresented: $isCreateStoryViewPresented) {
        CreateStoryView {}
      }
      .navigationDestination(for: String.self) { item in
        switch item {
        default:
          EmptyView()
        }
      }
    }
  }
}

#Preview {
  AvatarHomeView()
}
