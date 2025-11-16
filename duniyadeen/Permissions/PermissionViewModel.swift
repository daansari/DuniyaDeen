import Foundation
import Combine

final class PermissionViewModel: ObservableObject {
    @Published var model = PermissionModel()
    private let interactor: PermissionInteracting

    init(interactor: PermissionInteracting = PermissionInteractor()) {
        self.interactor = interactor
    }

    @MainActor
    func refreshAll() async {
        let newModel = await interactor.checkAllStatus()
        self.model = newModel
    }

    @MainActor
    func requestNotifications() async {
        let newModel = await interactor.requestNotifications()
        self.model = newModel
    }

    @MainActor
    func requestLocation() async {
        let newModel = await interactor.requestLocation()
        self.model = newModel
    }

    @MainActor
    func requestMicrophone() async {
        let newModel = await interactor.requestMicrophone()
        self.model = newModel
    }

    @MainActor
    func requestSpeech() async {
        let newModel = await interactor.requestSpeech()
        self.model = newModel
    }

    @MainActor
    func requestCalendarWriteOnly() async {
        let newModel = await interactor.requestCalendarWriteOnly()
        self.model = newModel
    }
}
