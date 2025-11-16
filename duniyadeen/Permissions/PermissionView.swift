import SwiftUI

// MARK: - View
struct PermissionView: View {
    @State private var model = PermissionModel()
    let interactor: PermissionInteracting

    init(interactor: PermissionInteracting = PermissionInteractor()) {
        self.interactor = interactor
    }

    var body: some View {
        ZStack {
            AppBackgroundGradient()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("We need a couple of permissions")
                        .font(.title2).bold()
                        .foregroundStyle(.white)
                    Text("Enable notifications and location to get timely updates and local experiences.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.8))
                }

                VStack(spacing: 12) {
                    permissionRow(
                        title: "Notifications",
                        status: model.notificationsAuthorized,
                        isBusy: model.isRequestInFlight
                    ) {
                        Task {
                            let newModel = await interactor.requestNotifications()
                            await MainActor.run { model = newModel }
                        }
                    }

                    permissionRow(
                        title: "Location",
                        status: model.locationAuthorized,
                        isBusy: model.isRequestInFlight
                    ) {
                        Task {
                            let newModel = await interactor.requestLocation()
                            await MainActor.run { model = newModel }
                        }
                    }
                }

                if let error = model.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }

                Spacer(minLength: 0)

                Button(action: {}) {
                    Text(model.allGranted ? "Continue" : "Skip for now")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .foregroundStyle(.white)
                }
            }
            .padding(24)
        }
        .task {
            let newModel = await interactor.checkCurrentStatus()
            await MainActor.run { model = newModel }
        }
    }

    @ViewBuilder
    private func permissionRow(title: String, status: Bool?, isBusy: Bool, action: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(status == true ? Color.green.opacity(0.8) : Color.yellow.opacity(0.8))
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(.white)
                Text(statusText(for: status))
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
            Button(action: action) {
                HStack(spacing: 8) {
                    if isBusy && status != true { ProgressView().tint(.white) }
                    Text(status == true ? "Granted" : "Allow")
                        .font(.subheadline.weight(.semibold))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.opacity(status == true ? 0.12 : 0.22))
                )
                .foregroundStyle(.white)
            }
            .disabled(status == true || isBusy)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(.white.opacity(0.08))
        )
    }

    private func statusText(for status: Bool?) -> String {
        switch status {
        case .some(true): return "Enabled"
        case .some(false): return "Denied"
        case .none: return "Not determined"
        }
    }
}

#Preview("Permission View") {
    PermissionView()
}
