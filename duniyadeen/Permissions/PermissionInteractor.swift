import Foundation

// MARK: - Interactor
protocol PermissionInteracting {
    func checkCurrentStatus() async -> PermissionModel
    func requestNotifications() async -> PermissionModel
    func requestLocation() async -> PermissionModel
    func requestMicrophone() async -> PermissionModel
    func requestSpeech() async -> PermissionModel
}

final class PermissionInteractor: PermissionInteracting {
    private var model = PermissionModel()

    func checkCurrentStatus() async -> PermissionModel {
        // TODO: Replace with real permission checks
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
}
