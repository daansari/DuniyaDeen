import SwiftUI
import Combine

// MARK: - MVI State
struct WelcomeHubState {
    var roll: Double = 0
    var pitch: Double = 0
}

// MARK: - MVI Intent
enum WelcomeHubIntent {
    case onAppear
    case onDisappear
    case scenePhaseChanged(ScenePhase)
}

// MARK: - MVI Store
final class WelcomeHubStore: ObservableObject {
    @Published private(set) var state = WelcomeHubState()
    private let interactor: WelcomeHubInteractor

    init(interactor: WelcomeHubInteractor = WelcomeHubInteractor()) {
        self.interactor = interactor
    }

    func send(_ intent: WelcomeHubIntent) {
        switch intent {
        case .onAppear:
            interactor.startMotion { [weak self] roll, pitch in
                guard let self = self else { return }
                self.state.roll = roll
                self.state.pitch = pitch
            }

        case .onDisappear:
            interactor.stopMotion()

        case .scenePhaseChanged(let phase):
            switch phase {
            case .active:
                interactor.startMotion { [weak self] roll, pitch in
                    guard let self = self else { return }
                    self.state.roll = roll
                    self.state.pitch = pitch
                }
            default:
                interactor.stopMotion()
            }
        }
    }
}
