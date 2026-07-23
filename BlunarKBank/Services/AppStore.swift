import Foundation
import UIKit

@MainActor
final class AppStore: ObservableObject {
    @Published var cards: [StoredCard] = [] { didSet { saveCards() } }
    @Published var subscription = SubscriptionState(firstAccess: Date(), activeUntil: nil) { didSet { saveSubscription() } }
    @Published var plans: [SubscriptionPlan] = [
        .init(id: "monthly", title: "Mensual", priceCUP: 100, days: 30),
        .init(id: "yearly", title: "Anual", priceCUP: 1000, days: 365)
    ]

    private let defaults = UserDefaults.standard
    let subscriptionAPIBaseURL = URL(string: "https://tu-servidor.com/api/subscription")!

    init() {
        if let data = defaults.data(forKey: "cards"), let value = try? JSONDecoder().decode([StoredCard].self, from: data) { cards = value }
        if let data = defaults.data(forKey: "subscription"), let value = try? JSONDecoder().decode(SubscriptionState.self, from: data) { subscription = value }
    }

    func loadPlans() async {
        // Producción: GET /plans. Se conservan precios de respaldo si el servidor no responde.
        let url = subscriptionAPIBaseURL.appending(path: "plans")
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
            plans = try JSONDecoder().decode([SubscriptionPlan].self, from: data)
        } catch { }
    }

    func activateDemo(plan: SubscriptionPlan) {
        let start = max(Date(), subscription.activeUntil ?? .distantPast)
        subscription.activeUntil = Calendar.current.date(byAdding: .day, value: plan.days, to: start)
    }

    func copy(_ value: String) { UIPasteboard.general.string = value }

    private func saveCards() { if let d = try? JSONEncoder().encode(cards) { defaults.set(d, forKey: "cards") } }
    private func saveSubscription() { if let d = try? JSONEncoder().encode(subscription) { defaults.set(d, forKey: "subscription") } }
}
