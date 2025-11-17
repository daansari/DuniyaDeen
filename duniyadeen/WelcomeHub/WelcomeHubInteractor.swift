import Foundation
import CoreMotion

final class WelcomeHubInteractor {
    private let manager = CMMotionManager()
    private var filteredRoll: Double = 0
    private var filteredPitch: Double = 0
    private let smoothingFactor: Double = 0.1 // lower = smoother

    func startMotion(update: @escaping (_ roll: Double, _ pitch: Double) -> Void) {
        guard manager.isDeviceMotionAvailable else { return }
        guard !manager.isDeviceMotionActive else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self = self, let m = motion else { return }
            let newRoll = m.attitude.roll
            let newPitch = m.attitude.pitch
            self.filteredRoll = self.filteredRoll + self.smoothingFactor * (newRoll - self.filteredRoll)
            self.filteredPitch = self.filteredPitch + self.smoothingFactor * (newPitch - self.filteredPitch)
            update(self.filteredRoll, self.filteredPitch)
        }
    }

    func stopMotion() {
        guard manager.isDeviceMotionActive else { return }
        manager.stopDeviceMotionUpdates()
    }
}
