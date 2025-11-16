import Foundation

// MARK: - Model
struct PermissionModel: Equatable {
    var notificationsAuthorized: Bool? = nil
    var locationAuthorized: Bool? = nil
    var microphoneAuthorized: Bool? = nil
    var speechAuthorized: Bool? = nil
    var isRequestInFlight: Bool = false
    var errorMessage: String? = nil

    var allGranted: Bool {
        (notificationsAuthorized ?? false)
        && (locationAuthorized ?? false)
        && (microphoneAuthorized ?? false)
        && (speechAuthorized ?? false)
    }
}
