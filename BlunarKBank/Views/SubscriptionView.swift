import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject private var store: AppStore
    let blocking: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:20) {
                    Image(systemName:"lock.shield.fill").font(.system(size:64)).foregroundStyle(.blue)
                    Text(store.subscription.isTrialActive ? "Prueba gratuita" : "Suscríbete para continuar").font(.largeTitle.bold()).multilineTextAlignment(.center)
                    if store.subscription.isTrialActive {
                        Text("Tienes \(trialDays) días de prueba disponibles.").foregroundStyle(.secondary)
                    } else if store.subscription.isPaidActive, let until=store.subscription.activeUntil {
                        Text("Activa hasta \(until.formatted(date:.abbreviated,time:.omitted))").foregroundStyle(.green)
                    } else {
                        Text("La aplicación permanece bloqueada hasta validar un pago en el servidor.").foregroundStyle(.secondary).multilineTextAlignment(.center)
                    }
                    ForEach(store.plans,id:\.id) { plan in
                        VStack(alignment:.leading,spacing:10) {
                            HStack { Text(plan.title).font(.title2.bold()); Spacer(); Text("\(plan.priceCUP) CUP").font(.title3.bold()) }
                            Text("Acceso por \(plan.days) días").foregroundStyle(.secondary)
                            Button("Pagar \(plan.title.lowercased())") {
                                // Prototipo: sustituir por POST /checkout y validación del servidor.
                                store.activateDemo(plan:plan)
                                if !blocking { dismiss() }
                            }.buttonStyle(.borderedProminent).frame(maxWidth:.infinity)
                        }.padding().background(.thinMaterial,in:RoundedRectangle(cornerRadius:20))
                    }
                    Text("Los precios y la activación proceden del servidor. La app no permite modificarlos.").font(.footnote).foregroundStyle(.secondary)
                }.padding()
            }
            .navigationTitle("Suscripción")
            .toolbar { if !blocking { ToolbarItem(placement:.cancellationAction) { Button("Cerrar") { dismiss() } } } }
        }.task { await store.loadPlans() }
    }
    private var trialDays:Int { max(0,Calendar.current.dateComponents([.day],from:Date(),to:store.subscription.firstAccess.addingTimeInterval(7*86400)).day ?? 0) }
}
