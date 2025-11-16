import Foundation
import EventKit
import UserNotifications
import Speech

// MARK: - Interactor
protocol PermissionInteracting {
    func checkAllStatus() async -> PermissionModel
    func checkCalendarCurrentStatus() async -> PermissionModel
    func requestNotifications() async -> PermissionModel
    func requestLocation() async -> PermissionModel
    func requestMicrophone() async -> PermissionModel
    func requestSpeech() async -> PermissionModel
    func requestCalendarWriteOnly() async -> PermissionModel
}

final class PermissionInteractor: PermissionInteracting {
    private var model = PermissionModel()
    
    func checkAllStatus() async -> PermissionModel {
        return model
    }

    func checkCalendarCurrentStatus() async -> PermissionModel {
        // Check current permission statuses. Replace with real permission checks as needed.
        // Calendar write-only status (iOS 17+) or full access fallback
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        
        case .notDetermined:
            model.calendarWriteAuthorized = nil
        case .denied, .restricted: model.calendarWriteAuthorized = false
        case .fullAccess:
            model.calendarWriteAuthorized = true
        case .writeOnly:
            model.calendarWriteAuthorized = true
        @unknown default: model.calendarWriteAuthorized = nil
        }
        return model
    }

    func requestNotifications() async -> PermissionModel {
        model.isRequestInFlight = true
        // Simulate async request
        try? await Task.sleep(nanoseconds: 500_000_000)
        model.isRequestInFlight = false
        model.notificationsAuthorized = true
        return model
    }

    func requestLocation() async -> PermissionModel {
        model.isRequestInFlight = true
        // Simulate async request
        try? await Task.sleep(nanoseconds: 500_000_000)
        model.isRequestInFlight = false
        model.locationAuthorized = true
        return model
    }

    func requestMicrophone() async -> PermissionModel {
        model.isRequestInFlight = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        model.isRequestInFlight = false
        model.microphoneAuthorized = true
        return model
    }

    func requestSpeech() async -> PermissionModel {
        model.isRequestInFlight = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        model.isRequestInFlight = false
        model.speechAuthorized = true
        return model
    }
    
    func requestCalendarWriteOnly() async -> PermissionModel {
        model.isRequestInFlight = true
        defer { model.isRequestInFlight = false }
        let store = EKEventStore()
        if #available(iOS 17.0, *) {
            do {
                try await store.requestWriteOnlyAccessToEvents()
                model.calendarWriteAuthorized = true
            } catch {
                model.calendarWriteAuthorized = false
                model.errorMessage = error.localizedDescription
            }
        } else {
            // Fallback: request full access on earlier OS versions
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                store.requestAccess(to: .event) { granted, err in
                    self.model.calendarWriteAuthorized = granted
                    if let err = err { self.model.errorMessage = err.localizedDescription }
                    continuation.resume()
                }
            }
        }
        return model
    }
}

