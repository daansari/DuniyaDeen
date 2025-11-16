import Foundation

// MARK: - Location Permission Model
struct LocationPermission: Equatable {
    enum Status: Equatable {
        case notDetermined
        case denied
        case restricted
        case whenInUse
        case always
    }

    var status: Status? = nil
    var precise: Bool? = nil
    var servicesEnabled: Bool? = nil

    var isAuthorized: Bool? {
        switch status {
        case .some(.always), .some(.whenInUse):
            return true
        case .some(.denied), .some(.restricted):
            return false
        case .some(.notDetermined), .none:
            return nil
        }
    }
}

// MARK: - Model
struct PermissionModel: Equatable {
    var notificationsAuthorized: Bool? = nil
    var location: LocationPermission = .init()
    var microphoneAuthorized: Bool? = nil
    var speechAuthorized: Bool? = nil
    var calendarWriteAuthorized: Bool? = nil
    var isRequestInFlight: Bool = false
    var errorMessage: String? = nil

    var allGranted: Bool {
        (notificationsAuthorized ?? false)
        && (location.isAuthorized ?? false)
        && (microphoneAuthorized ?? false)
        && (speechAuthorized ?? false)
        && (calendarWriteAuthorized ?? false)
    }
}

