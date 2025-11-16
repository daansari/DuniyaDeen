//
//  CalendarView.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            Button(action: createEvent) {
                Text("Create a calendar event")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.accentColor.opacity(0.15)))
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
        }
        .navigationTitle("Calendar")
    }

    private func createEvent() {
        // TODO: Hook up to EventKit or your event creation flow.
        print("Create calendar event tapped")
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
