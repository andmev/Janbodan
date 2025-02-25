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
      }
    }
    .mapStyle(.standard)
    .sheet(isPresented: $showSheet) {
      Text("Selected item:")
        .interactiveDismissDisabled(true)
        .presentationCornerRadius(21)
        .presentationBackground(.thinMaterial)
        .presentationDetents(
          [.height(256), .large]
        )
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

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
