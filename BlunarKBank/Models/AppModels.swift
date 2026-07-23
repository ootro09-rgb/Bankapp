import Foundation

enum Bank: String, CaseIterable, Codable, Identifiable {
    case banmet = "BANMET"
    case bpa = "BPA"
    case bandec = "BANDEC"
    var id: String { rawValue }
    var code: String { switch self { case .bpa: "01"; case .bandec: "02"; case .banmet: "03" } }
}

struct StoredCard: Identifiable, Codable, Hashable {
    var id = UUID()
    var alias: String
    var number: String
    var currency: String
    var bank: Bank
    var last4: String { String(number.filter(\.isNumber).suffix(4)) }
}

struct BankAction: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
    let systemImage: String
    let flow: Flow
    enum Flow: Hashable { case direct, transfer, mobileRecharge }
}

struct SubscriptionPlan: Codable, Hashable {
    let id: String
    let title: String
    let priceCUP: Int
    let days: Int
}

struct SubscriptionState: Codable {
    var firstAccess: Date
    var activeUntil: Date?
    var isTrialActive: Bool { Date() < firstAccess.addingTimeInterval(7*86400) && !isPaidActive }
    var isPaidActive: Bool { (activeUntil ?? .distantPast) > Date() }
    var canUseApp: Bool { isTrialActive || isPaidActive }
}
