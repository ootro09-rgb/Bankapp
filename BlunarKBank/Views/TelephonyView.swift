import SwiftUI

struct TelephonyView: View {
    private let actions:[(String,String,String)] = [
        ("Consultar saldo","*222#","dollarsign.circle"),
        ("Consultar datos","*222*328#","antenna.radiowaves.left.and.right"),
        ("Bonos y planes USD","*222*266#","gift.fill"),
        ("Plan de voz","*222*869#","phone.fill"),
        ("Plan de SMS","*222*767#","message.fill"),
        ("Plan Amigos","*222*264#","person.2.fill"),
        ("Comprar planes","*133#","cart.fill"),
        ("Transferir o adelantar saldo","*234#","arrow.left.arrow.right"),
        ("Atención al cliente","2266","headphones")
    ]
    var body: some View {
        List(actions,id:\.0) { item in
            Button { USSDService.open(item.1) } label: { Label(item.0,systemImage:item.2).foregroundStyle(.primary) }
        }.navigationTitle("Telefonía")
    }
}
