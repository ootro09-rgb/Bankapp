import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore
    @Binding var showScanner: Bool
    @State private var showAdd = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("BlunarKBank").font(.largeTitle.bold())
                        Text("Tus tarjetas y servicios").foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button { showScanner = true } label: {
                        Image(systemName: "viewfinder.rectangular")
                            .font(.title2).padding(12).background(.blue.opacity(0.2), in: Circle())
                    }.accessibilityLabel("Escanear QR o tarjeta")
                }
                if store.cards.isEmpty {
                    ContentUnavailableView("Sin tarjetas", systemImage: "creditcard", description: Text("Añade tu primera tarjeta para comenzar."))
                }
                ForEach(store.cards) { card in
                    NavigationLink(value: card.bank) {
                        CardVisual(card: card)
                    }.buttonStyle(.plain)
                }
                Button { showAdd = true } label: { Label("Añadir tarjeta", systemImage: "plus.circle.fill").frame(maxWidth: .infinity) }
                    .buttonStyle(.borderedProminent).controlSize(.large)
            }.padding()
        }
        .navigationDestination(for: Bank.self) { BankActionsView(bank: $0) }
        .sheet(isPresented: $showAdd) { AddCardView() }
    }
}

struct CardVisual: View {
    let card: StoredCard
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24).fill(background)
            VStack(alignment: .leading, spacing: 18) {
                HStack { Image(systemName: "creditcard.fill"); Spacer(); Text(card.currency).bold() }
                Spacer()
                Text(card.alias).font(.headline)
                Text("••••  ••••  ••••  \(card.last4)").font(.title3.monospaced())
            }.padding(20).foregroundStyle(foreground)
        }.frame(height: 205).shadow(radius: 8, y: 4)
    }
    private var background: some ShapeStyle {
        switch card.bank { case .banmet: AnyShapeStyle(LinearGradient(colors:[.gray.opacity(.85),.green], startPoint:.top, endPoint:.bottom)); case .bpa: AnyShapeStyle(LinearGradient(colors:[.white,.green.opacity(.7)], startPoint:.topLeading, endPoint:.bottomTrailing)); case .bandec: AnyShapeStyle(LinearGradient(colors:[.red,.red.opacity(.55)], startPoint:.topLeading, endPoint:.bottomTrailing)) }
    }
    private var foreground: Color { card.bank == .bpa ? .black : .white }
}

struct AddCardView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var alias=""
    @State private var number=""
    @State private var currency="CUP"
    @State private var bank: Bank = .banmet
    var body: some View {
        NavigationStack {
            Form {
                TextField("Alias", text:$alias)
                TextField("Número de tarjeta", text:$number).keyboardType(.numberPad)
                Picker("Banco", selection:$bank) { ForEach(Bank.allCases) { Text($0.rawValue).tag($0) } }
                Picker("Moneda", selection:$currency) { Text("CUP").tag("CUP"); Text("MLC").tag("MLC"); Text("USD").tag("USD") }
            }
            .navigationTitle("Nueva tarjeta")
            .toolbar {
                ToolbarItem(placement:.cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement:.confirmationAction) { Button("Guardar") { store.cards.append(.init(alias:alias.isEmpty ? "Mi tarjeta":alias, number:number.filter(\.isNumber), currency:currency, bank:bank)); dismiss() }.disabled(number.filter(\.isNumber).count != 16) }
            }
        }
    }
}
