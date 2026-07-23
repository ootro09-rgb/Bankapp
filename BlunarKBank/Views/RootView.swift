import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showScanner = false

    var body: some View {
        Group {
            if store.subscription.canUseApp {
                MainTabView(showScanner: $showScanner)
            } else {
                SubscriptionView(blocking: true)
            }
        }
        .sheet(isPresented: $showScanner) { ScannerView() }
        .task { await store.loadPlans() }
    }
}

struct MainTabView: View {
    @Binding var showScanner: Bool
    var body: some View {
        TabView {
            NavigationStack { HomeView(showScanner: $showScanner) }
                .tabItem { Label("Inicio", systemImage: "house.fill") }
            NavigationStack { TelephonyView() }
                .tabItem { Label("Telefonía", systemImage: "iphone.gen3") }
            NavigationStack { BankSelectorView() }
                .tabItem { Label("Banco", systemImage: "building.columns.fill") }
            NavigationStack { SettingsView() }
                .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
        }
        .tint(.blue)
    }
}
