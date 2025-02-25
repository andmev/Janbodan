//
//  ContentView.swift
//  Janbodan
//
//  Created by Andrii Medvediev on 25.02.2025.
//

import MapKit
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]

  // Map state
  @State private var position: MapCameraPosition = .automatic
  @State private var selectedItem: MKMapItem? = nil

  @State private var showSheet: Bool = false

  var body: some View {
    Map(position: $position, selection: $selectedItem) {
      ForEach(items) { item in
        // We could add markers here if Item had location data
        Marker("Item \(item.timestamp.formatted())", coordinate: .init(latitude: 0, longitude: 0))
          .tag(item.id)
      }
    }
    .mapStyle(
      .standard(
        elevation: .realistic,
        pointsOfInterest: .all,
        showsTraffic: true
      )
    )
    .overlay(alignment: .topTrailing) {
      VStack {
        AvatarView()
      }
      .padding(.trailing)
      .buttonBorderShape(.circle)
    }
    .mapControlVisibility(.hidden)
    .sheet(isPresented: $showSheet) {
      Text("Selected item:")
        .presentationBackground(.thinMaterial)
        .presentationCornerRadius(21)
        .presentationDetents([.height(256), .large])
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(true)
    }
    .onAppear {
      showSheet = true
    }
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(timestamp: Date())
      modelContext.insert(newItem)
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
}

/// A circular avatar image view that matches MapKit control styling
struct AvatarView: View {
  var body: some View {
    Button(action: {
      // Avatar action here
    }) {
      Image(systemName: "person.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 18, height: 18)
        .foregroundStyle(.primary)
        .padding(12)
    }
    .background(.ultraThickMaterial)
    .clipShape(Circle())
    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
