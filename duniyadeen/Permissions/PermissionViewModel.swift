import Foundation
import Combine

final class PermissionViewModel: ObservableObject {
    @Published var model = PermissionModel()
    private let interactor: PermissionInteracting

    init(interactor: PermissionInteracting = PermissionInteractor()) {
        self.interactor = interactor
    }

    func refreshAll() async {
        // Perform the heavy check off the main actor with an explicit weak self capture
        let newModel = await Task.detached(priority: .utility) { [weak self] () -> PermissionModel in
            guard let self = self else {
                // If the view model was deallocated, return an empty/default model
                return await PermissionModel()
            }
            return await self.interactor.checkAllStatus()
        }.value

        // Publish a single consolidated update on the main actor
        await MainActor.run {
            self.model = newModel
        }
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
