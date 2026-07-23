import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showSubscription=false
    var body: some View {
        List {
            Section("Cuenta") {
                Button { showSubscription=true } label: {
                    Label { VStack(alignment:.leading) { Text("Suscripción"); Text(status).font(.caption).foregroundStyle(.secondary) } } icon: { Image(systemName:"creditcard.fill") }
                }.foregroundStyle(.primary)
            }
            Section("Tarjetas") {
                ForEach(store.cards) { card in
                    HStack { Image(systemName:"creditcard"); VStack(alignment:.leading) { Text(card.alias); Text("•••• \(card.last4)").font(.caption).foregroundStyle(.secondary) }; Spacer(); Button(role:.destructive) { store.cards.removeAll{$0.id==card.id} } label:{Image(systemName:"trash")} }
                }
            }
            Section("Información") {
                NavigationLink { HelpView() } label:{ Label("Ayuda",systemImage:"questionmark.circle") }
                NavigationLink { AboutView() } label:{ Label("Acerca de",systemImage:"info.circle") }
            }
        }.navigationTitle("Ajustes").sheet(isPresented:$showSubscription){SubscriptionView(blocking:false)}
    }
    private var status:String {
        if store.subscription.isPaidActive,let d=store.subscription.activeUntil{return "Activa hasta \(d.formatted(date:.numeric,time:.omitted))"}
        if store.subscription.isTrialActive{return "Prueba gratuita activa"}
        return "Vencida · Toca para pagar"
    }
}

struct HelpView: View {
    var body: some View {
        List {
            Section("Escáner") {
                Text("El escáner lee automáticamente QR y números impresos. Si el QR contiene teléfono, texto y tarjeta, solo copia una secuencia de 16 dígitos, priorizando tarjetas cubanas que comienzan por 92.")
            }
            Section("Transferencias y recargas") {
                Text("Al transferir, selecciona una tarjeta para copiarla antes de abrir el USSD. Al recargar un móvil, selecciona un contacto y su número se copiará.")
            }
            Section("Seguridad") {
                Text("La versión de producción debe mover las tarjetas de UserDefaults a Keychain y validar suscripciones y pagos exclusivamente en el servidor.")
            }
        }.navigationTitle("Ayuda")
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section { HStack { Spacer(); VStack { Image(systemName:"building.columns.circle.fill").font(.system(size:70)).foregroundStyle(.blue); Text("BlunarKBank").font(.title.bold()); Text("Versión 1.0").foregroundStyle(.secondary) }; Spacer() } }
            Section("Aviso") { Text("BlunarKBank no es una aplicación oficial de ETECSA, Transfermóvil, BANMET, BPA ni BANDEC.") }
        }.navigationTitle("Acerca de")
    }
}
