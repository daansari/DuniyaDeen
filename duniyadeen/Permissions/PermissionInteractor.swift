import Foundation
import EventKit
import UserNotifications
import Speech
import CoreLocation
import AVFoundation
import AVFAudio

// MARK: - Interactor
protocol PermissionInteracting {
    func checkAllStatus() async -> PermissionModel
    func checkCalendarCurrentStatus() async -> PermissionModel
    func checkNotificationCurrentStatus() async -> PermissionModel
    func checkLocationCurrentStatus() async -> PermissionModel
    func checkMicrophoneCurrentStatus() async -> PermissionModel
    func checkSpeechCurrentStatus() async -> PermissionModel
    func requestNotifications() async -> PermissionModel
    func requestLocation() async -> PermissionModel
    func requestMicrophone() async -> PermissionModel
    func requestSpeech() async -> PermissionModel
    func requestCalendarWriteOnly() async -> PermissionModel
}

private final class LocationAuthProxy: NSObject, CLLocationManagerDelegate {
    var onChange: ((CLLocationManager) -> Void)?

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        onChange?(manager)
    }
}

final class PermissionInteractor: PermissionInteracting {
    private var model = PermissionModel()
    private var locationAuthProxy: LocationAuthProxy? = nil
    
    func checkAllStatus() async -> PermissionModel {
        var model = await self.checkCalendarCurrentStatus()
        model = await self.checkNotificationCurrentStatus()
        model = await self.checkLocationCurrentStatus()
        model = await self.checkMicrophoneCurrentStatus()
        model = await self.checkSpeechCurrentStatus()
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
    
    func checkNotificationCurrentStatus() async -> PermissionModel {
        let center = UNUserNotificationCenter.current()
        let settings: UNNotificationSettings = await withCheckedContinuation { continuation in
            center.getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }

        switch settings.authorizationStatus {
        case .notDetermined:
            model.notificationsAuthorized = nil
        case .denied:
            model.notificationsAuthorized = false
        case .authorized, .provisional, .ephemeral:
            model.notificationsAuthorized = true
        @unknown default:
            model.notificationsAuthorized = nil
        }
        return model
    }
    
    func checkLocationCurrentStatus() async -> PermissionModel {
        let manager = CLLocationManager()
        let status: CLAuthorizationStatus
        status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            model.location.servicesEnabled = nil
        case .denied, .restricted:
            model.location.servicesEnabled = false
        case .authorizedAlways, .authorizedWhenInUse:
            model.location.servicesEnabled = true
        @unknown default:
            model.location.servicesEnabled = nil
        }

        model.location.precise = (manager.accuracyAuthorization == .fullAccuracy)

        return model
    }
    
    func checkMicrophoneCurrentStatus() async -> PermissionModel {
        let permission = AVAudioApplication.shared.recordPermission
        switch permission {
        case .undetermined:
            model.microphoneAuthorized = nil
        case .denied:
            model.microphoneAuthorized = false
        case .granted:
            model.microphoneAuthorized = true
        @unknown default:
            model.microphoneAuthorized = nil
        }
        return model
    }
    
    func checkSpeechCurrentStatus() async -> PermissionModel {
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .notDetermined:
            model.speechAuthorized = nil
        case .denied, .restricted:
            model.speechAuthorized = false
        case .authorized:
            model.speechAuthorized = true
        @unknown default:
            model.speechAuthorized = nil
        }
        return model
    }

    func requestNotifications() async -> PermissionModel {
        model.isRequestInFlight = true
        defer { model.isRequestInFlight = false }

        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            model.notificationsAuthorized = granted
        } catch {
            model.notificationsAuthorized = false
            model.errorMessage = error.localizedDescription
        }

        return model
    }

    func requestLocation() async -> PermissionModel {
        model.isRequestInFlight = true
        defer { model.isRequestInFlight = false }

        let tempManager = CLLocationManager()
        let current: CLAuthorizationStatus
        current = tempManager.authorizationStatus
        // If already determined, don't prompt again; just reflect current status
        guard current == .notDetermined else {
            let model = await checkLocationCurrentStatus()
            return model
        }

        // Request When-In-Use authorization and await delegate callback
        let manager = CLLocationManager()
        let proxy = LocationAuthProxy()
        self.locationAuthProxy = proxy

        let status: CLAuthorizationStatus = await withCheckedContinuation { continuation in
            var didResume = false
            proxy.onChange = { mgr in
                let status = mgr.authorizationStatus
                // Only resume once the user has responded (status changes away from .notDetermined)
                guard status != .notDetermined else { return }
                guard !didResume else { return }
                didResume = true
                continuation.resume(returning: status)
            }
            manager.delegate = proxy
            manager.requestAlwaysAuthorization()
        }

        // Release proxy after we have a definitive status to avoid retaining it unnecessarily
        self.locationAuthProxy = nil

        switch status {
        case .denied, .restricted:
            model.location.servicesEnabled = false
        case .authorizedAlways, .authorizedWhenInUse:
            model.location.servicesEnabled = true
        case .notDetermined:
            model.location.servicesEnabled = nil
        @unknown default:
            model.location.servicesEnabled = nil
        }

        model.location.precise = (manager.accuracyAuthorization == .fullAccuracy)

        return model
    }

    func requestMicrophone() async -> PermissionModel {
        model.isRequestInFlight = true
        defer { model.isRequestInFlight = false }

        let granted: Bool = await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }
        model.microphoneAuthorized = granted
        return model
    }

    func requestSpeech() async -> PermissionModel {
        model.isRequestInFlight = true
        defer { model.isRequestInFlight = false }

        let status: SFSpeechRecognizerAuthorizationStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        switch status {
        case .authorized:
            model.speechAuthorized = true
        case .denied, .restricted:
            model.speechAuthorized = false
        case .notDetermined:
            model.speechAuthorized = nil
        @unknown default:
            model.speechAuthorized = nil
        }

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

