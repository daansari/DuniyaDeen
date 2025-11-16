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

            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // MARK: Header / Logo
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [AppTheme.palette.accentPrimary.opacity(0.28), .clear],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 120
                                        )
                                    )
                                    .frame(width: 140, height: 140)
                                    .blur(radius: 25)

                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.05))
                                    Image("AppLogo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 96, height: 96)
                                        .padding(26)
                                }
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.25), radius: 16, y: 8)
                            }
                            .frame(maxWidth: .infinity)

                            Text("Enable Permission")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            Text("Allow access to enhance functionality and improve experience.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.85))
                        }

                        // MARK: Cards
                        GlassEffectContainer(spacing: 18) {
                            VStack(spacing: 14) {
                                permissionCard(
                                    iconName: "bell.fill",
                                    title: "Notification Access",
                                    description: "Enable notifications to receive timely updates and stay informed about important alerts.",
                                    status: model.notificationsAuthorized,
                                    isBusy: model.isRequestInFlight,
                                    isActionable: true
                                ) {
                                    Task {
                                        let newModel = await interactor.requestNotifications()
                                        await MainActor.run { model = newModel }
                                    }
                                }

                                permissionCard(
                                    iconName: "calendar",
                                    title: "Calendar Access",
                                    description: "Grant calendar access to help schedule, track events, and receive smart reminders.",
                                    status: nil,
                                    isBusy: false,
                                    isActionable: false,
                                    action: {}
                                )

                                permissionCard(
                                    iconName: "mappin.and.ellipse",
                                    title: "Location Access",
                                    description: "Allow location access for personalized recommendations and local support based on your area.",
                                    status: model.locationAuthorized,
                                    isBusy: model.isRequestInFlight,
                                    isActionable: true
                                ) {
                                    Task {
                                        let newModel = await interactor.requestLocation()
                                        await MainActor.run { model = newModel }
                                    }
                                }

                                permissionCard(
                                    iconName: "mic.fill",
                                    title: "Microphone Access",
                                    description: "Allow microphone access for voice notes and audio features.",
                                    status: model.microphoneAuthorized,
                                    isBusy: model.isRequestInFlight,
                                    isActionable: true
                                ) {
                                    Task {
                                        let newModel = await interactor.requestMicrophone()
                                        await MainActor.run { model = newModel }
                                    }
                                }

                                permissionCard(
                                    iconName: "waveform",
                                    title: "Speech Recognizer",
                                    description: "Enable speech recognition for voice commands and transcription.",
                                    status: model.speechAuthorized,
                                    isBusy: model.isRequestInFlight,
                                    isActionable: true
                                ) {
                                    Task {
                                        let newModel = await interactor.requestSpeech()
                                        await MainActor.run { model = newModel }
                                    }
                                }
                            }
                        }

                        if let error = model.errorMessage {
                            Text(error)
                                .foregroundStyle(.red)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 24))
                    .padding(.top, 0)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    VStack(spacing: 0) {
                        Button(action: enableAll) {
                            Text(model.allGranted ? "Continue" : "Enable Permission")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .background(
                            LinearGradient(
                                colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: AppTheme.palette.accentSecondary.opacity(0.35), radius: 16, y: 8)
                        .disabled(model.isRequestInFlight)
                    }
                    .padding(.horizontal, 20)
//                    .padding(.bottom, max(geo.safeAreaInsets.bottom, 12))
                    .padding(.top, 16)
                    .background {
                        Rectangle()
                            .fill(Color.clear)
                            .glassEffect(
                                .regular
                                    .tint(AppTheme.palette.accentPrimary.opacity(0.18))
                                    .interactive()
                                , in: .rect(cornerRadius: 0)
                            )
                            .ignoresSafeArea(edges: .bottom)
                    }
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 1),
                        alignment: .top
                    )
                }
            }
        }
        .task {
            let newModel = await interactor.checkCurrentStatus()
            await MainActor.run { model = newModel }
        }
    }

    @ViewBuilder
    private func permissionCard(
        iconName: String,
        title: String,
        description: String,
        status: Bool?,
        isBusy: Bool,
        isActionable: Bool,
        action: @escaping () -> Void
    ) -> some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.palette.accentPrimary, AppTheme.palette.accentSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image(systemName: iconName)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(width: 34, height: 34)
            .shadow(color: AppTheme.palette.accentSecondary.opacity(0.25), radius: 8, y: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color("BaseTextColor"))
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(Color("SecondaryTextColor"))
            }

            Spacer(minLength: 8)

            if isActionable {
                Button(action: action) {
                    HStack(spacing: 8) {
                        if isBusy && status != true { ProgressView().tint(Color("BaseTextColor")) }
                        Text(status == true ? "Granted" : "Allow")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white.opacity(status == true ? 0.12 : 0.22))
                    )
                    .foregroundStyle(Color("BaseTextColor"))
                }
                .disabled(status == true || isBusy)
            } else {
                Text("Optional")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("BaseTextColor"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white.opacity(0.10))
                    )
            }
        }
        .padding(14)
        .glassEffect(
            .regular
//                .tint(AppTheme.palette.accentPrimary.opacity(0.5))
                .interactive(),
            in: .rect(cornerRadius: 20)
        )
    }

    private func enableAll() {
        guard !model.allGranted else { return }
        Task {
            if model.notificationsAuthorized != true {
                let m = await interactor.requestNotifications()
                await MainActor.run { model = m }
            }
            if model.locationAuthorized != true {
                let m = await interactor.requestLocation()
                await MainActor.run { model = m }
            }
            if model.microphoneAuthorized != true {
                let m = await interactor.requestMicrophone()
                await MainActor.run { model = m }
            }
            if model.speechAuthorized != true {
                let m = await interactor.requestSpeech()
                await MainActor.run { model = m }
            }
        }
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
