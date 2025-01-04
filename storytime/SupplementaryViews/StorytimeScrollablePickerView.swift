//
//  StorytimeScrollablePickerView.swift
//  storytime
//
//  Created by Amanda Peterson on 12/30/24.
//

import SwiftUI

protocol StorytimeScrollablePickerViewData: CustomStringConvertible, Identifiable, Hashable {
}

// Need to use a generic parameter `T` because only concrete
// types such as structs, enums and classes can conform to protocols.
struct StorytimeScrollablePickerView<T: StorytimeScrollablePickerViewData>: View {
  private let HORIZONTAL_PADDING = CGFloat(15)

  let allItems: [T]
  @Binding var selectedItems: Set<T>
  @State var isSingleSelection = false

  var resetButtonForegroundColor: Color {
    selectedItems.isEmpty ? .white : .black
  }

  var resetButtonBackgroundColor: Color {
    selectedItems.isEmpty ? .blue : .white
  }

  func buttonForegroundColor(for item: T) -> Color {
    selectedItems.contains(item) ? .white : .black
  }

  func buttonBackgroundColor(for item: T) -> Color {
    selectedItems.contains(item) ? .blue : .white
  }

  func tapped(item: T) {
    if isSingleSelection {
      selectedItems.removeAll()
      selectedItems.insert(item)
    } else {
      if selectedItems.contains(item) {
        selectedItems.remove(item)
      } else {
        selectedItems.insert(item)
      }
    }
  }

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        if !isSingleSelection {
          Button {
            guard !selectedItems.isEmpty else { return }
            selectedItems.removeAll()
          } label: {
            Text("All")
              .foregroundStyle(resetButtonForegroundColor)
              .frame(height: 30)
              .padding(.horizontal, HORIZONTAL_PADDING)
              .background(resetButtonBackgroundColor)
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .overlay {
                if !selectedItems.isEmpty {
                  RoundedRectangle(cornerRadius: 10)
                    .stroke(.black.tertiary, lineWidth: 1)
                }
              }
          }
        }

        ForEach(allItems, id: \.id) { item in
          Button {
            tapped(item: item)
          } label: {
            Text(verbatim: "\(item)")
              .foregroundStyle(buttonForegroundColor(for: item))
              .frame(height: 30)
              .padding(.horizontal, HORIZONTAL_PADDING)
              .background(buttonBackgroundColor(for: item))
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .overlay {
                if !selectedItems.contains(item) {
                  RoundedRectangle(cornerRadius: 10)
                    .stroke(.black.tertiary, lineWidth: 1)
                }
              }
          }
        }
      }
      .padding(.horizontal)
    }
    .scrollIndicators(.never)
  }
}

#Preview {
  @Previewable @State var selectedGenericEnumsInts = Set<StorytimeGenericEnum<Int>>()
  @Previewable @State var selectedGenericEnumsFloats = Set<StorytimeGenericEnum<CGFloat>>()
  @Previewable @State var selectedGenericEnumsStrings = Set<StorytimeGenericEnum<String>>()
  @Previewable @State var singleSelectionGenericEnumsStrings = Set<StorytimeGenericEnum<String>>()

  let genericEnumsInts: [StorytimeGenericEnum<Int>] = [
    .value(someValue: 2000),
    .value(someValue: 2001),
    .value(someValue: 2002)
  ]
  let genericEnumsCGFloats: [StorytimeGenericEnum<CGFloat>] = [
    .value(someValue: 0.123),
    .value(someValue: 1.901),
    .value(someValue: 2.0121)
  ]
  let genericEnumsStrings: [StorytimeGenericEnum<String>] = [
    .value(someValue: "abcd"),
    .value(someValue: "1212"),
    .value(someValue: "abcD")
  ]

  StorytimeScrollablePickerView<StorytimeGenericEnum<Int>>(
    allItems: genericEnumsInts,
    selectedItems: $selectedGenericEnumsInts
  )
  StorytimeScrollablePickerView<StorytimeGenericEnum<CGFloat>>(
    allItems: genericEnumsCGFloats,
    selectedItems: $selectedGenericEnumsFloats
  )
  StorytimeScrollablePickerView<StorytimeGenericEnum<String>>(
    allItems: genericEnumsStrings,
    selectedItems: $selectedGenericEnumsStrings
  )
  StorytimeScrollablePickerView<StorytimeGenericEnum<String>>(
    allItems: genericEnumsStrings,
    selectedItems: $singleSelectionGenericEnumsStrings,
    isSingleSelection: true
  )
}

enum StorytimeGenericEnum<T>: StorytimeScrollablePickerViewData where T: Comparable, T: Hashable {
  case value(someValue: T)

  var id: Self { self }

  var description: String {
    switch self {
    case .value(let someValue):
      return "\(someValue)"
    }
  }
}

extension StorytimeGenericEnum: Identifiable {
  static func == (lhs: StorytimeGenericEnum<T>, rhs: StorytimeGenericEnum<T>) -> Bool {
    switch lhs {
    case .value(let lhsValue):
      switch rhs {
      case .value(let rhsValue):
        return lhsValue == rhsValue
      }
    }
  }
}
