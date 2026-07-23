import SwiftUI

struct BankSelectorView: View {
    var body: some View {
        List(Bank.allCases) { bank in
            NavigationLink(value: bank) { Label(bank.rawValue, systemImage:"building.columns.fill") }
        }
        .navigationTitle("Banco")
        .navigationDestination(for: Bank.self) { BankActionsView(bank:$0) }
    }
}

struct BankActionsView: View {
    @EnvironmentObject private var store: AppStore
    let bank: Bank
    @State private var transferAction: BankAction?
    @State private var contactAction: BankAction?
    @State private var showContacts=false
    @State private var toast=""

    var body: some View {
        List(USSDService.actions(for:bank)) { action in
            Button { run(action) } label: {
                Label(action.name, systemImage:action.systemImage).foregroundStyle(.primary)
            }
        }
        .navigationTitle(bank.rawValue)
        .confirmationDialog("Selecciona una tarjeta", item:$transferAction) { action in
            ForEach(store.cards) { card in
                Button("\(card.alias) · •••• \(card.last4)") {
                    store.copy(card.number)
                    toast="Número de tarjeta copiado"
                    USSDService.open(action.code)
                }
            }
        }
        .sheet(isPresented:$showContacts) {
            ContactPicker { number in
                store.copy(number)
                showContacts=false
                toast="Número del contacto copiado"
                if let action=contactAction { DispatchQueue.main.asyncAfter(deadline:.now()+0.3) { USSDService.open(action.code) } }
            }
        }
        .overlay(alignment:.bottom) { if !toast.isEmpty { Text(toast).padding().background(.ultraThinMaterial,in:Capsule()).padding().task { try? await Task.sleep(for:.seconds(2)); toast="" } } }
    }

    private func run(_ action: BankAction) {
        switch action.flow {
        case .direct: USSDService.open(action.code)
        case .transfer: transferAction=action
        case .mobileRecharge: contactAction=action; showContacts=true
        }
    }
}
