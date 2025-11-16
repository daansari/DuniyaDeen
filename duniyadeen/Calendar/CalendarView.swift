//
//  CalendarView.swift
//  duniyadeen
//
//  Created by Danish Ahmed Ansari on 16/11/25.
//

import EventKit
import EventKitUI
import SwiftUI

struct CalendarView: View {
    @State private var showingEventEditor = false
    @State private var eventStore = EKEventStore()
    
    var body: some View {
        ZStack {
            AppBackgroundGradient()
            Color(.systemBackground)
                .ignoresSafeArea()

            Button(action: requestAccessAndShowEditor) {
                Text("Create a calendar event")
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
//                    .background(Capsule().fill(Color.accentColor.opacity(0.15)))
            }
            .buttonStyle(CapsuleFillButtonStyle())
            .padding(24)
            .frame(maxWidth: 360)
        }
//        .navigationTitle("Calendar")
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingEventEditor) {
            EventEditView(eventStore: eventStore) { result in
                // Handle the result if needed
                showingEventEditor = false
            }
        }
    }

    private func requestAccessAndShowEditor() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            showingEventEditor = true
        case .notDetermined:
            eventStore.requestWriteOnlyAccessToEvents(completion: { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        showingEventEditor = true
                    }
                }
            })
        case .denied, .restricted, .fullAccess:
            // Consider guiding the user to Settings if access is denied/restricted
            break
        case .writeOnly:
            showingEventEditor = true
        @unknown default:
            break
        }
    }

    private struct EventEditView: UIViewControllerRepresentable {
        typealias UIViewControllerType = EKEventEditViewController

        let eventStore: EKEventStore
        var onComplete: (EKEventEditViewAction) -> Void

        func makeUIViewController(context: Context) -> EKEventEditViewController {
            let vc = EKEventEditViewController()
            vc.eventStore = eventStore
            vc.editViewDelegate = context.coordinator

            // Preconfigure a new event (optional)
            let event = EKEvent(eventStore: eventStore)
            event.isAllDay = true
            event.title = "New Event"
            // Start 3 days from now
            event.startDate = Date().addingTimeInterval(3 * 24 * 60 * 60)
            // End of the same date
            event.endDate = event.startDate
            // Set alert on the day of event at 9 am
            event.alarms = [EKAlarm(absoluteDate: event.startDate.addingTimeInterval(9 * 60 * 60))]
            vc.event = event
            return vc
        }

        func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(onComplete: onComplete)
        }

        final class Coordinator: NSObject, EKEventEditViewDelegate {
            var onComplete: (EKEventEditViewAction) -> Void

            init(onComplete: @escaping (EKEventEditViewAction) -> Void) {
                self.onComplete = onComplete
            }

            func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
                controller.dismiss(animated: true)
                onComplete(action)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
}
