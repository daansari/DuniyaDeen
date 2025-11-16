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
//            event.calendar = eventStore.defaultCalendarForNewEvents
            event.isAllDay = true
            event.title = "New Event"
            // Start 3 days from now
            let tomorrow = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
            event.startDate = Calendar.current.startOfDay(for: tomorrow)
            event.endDate = Calendar.current.date(byAdding: .day, value: 1, to: event.startDate)!
            // Set alert use relativeOffset of 9 hours on the day of the event
            // Add an alarm with a relative offset (e.g., 30 minutes before the event start time)
            // Note: The system will adjust this for all-day events according to user's default settings
            // or apply the relative offset at 9:00 AM on the event day if no time is specified.
//            let alarmOffset = 9 * 60.0 * 60.0 // 30 minutes after
//            let alarm = EKAlarm(relativeOffset: alarmOffset)
//            event.alarms = [alarm]
            
            let alarmOffset = -30.0 * 60.0 // 30 minutes before
            let alarm = EKAlarm(relativeOffset: alarmOffset)
            event.alarms = [alarm]
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
