import Foundation

extension PermissionModel {
    // Backward compatibility for existing code that used `locationAuthorized`
    var locationAuthorized: Bool? {
        get { location.isAuthorized }
        set {
            guard let newValue = newValue else {
                location.status = .notDetermined
                return
            }
            location.status = newValue ? .whenInUse : .denied
        }
    }

    // Backward compatibility for earlier precise location flag usage
    var preciseLocationEnabled: Bool? {
        get { location.precise }
        set { location.precise = newValue }
    }
}
