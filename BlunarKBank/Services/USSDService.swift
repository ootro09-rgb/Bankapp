import UIKit

enum USSDService {
    static func open(_ code: String) {
        let encoded = code.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? code
        guard let url = URL(string: "tel://\(encoded)") else { return }
        UIApplication.shared.open(url)
    }

    static func actions(for bank: Bank) -> [BankAction] {
        let auth = BankAction(name: "Autenticarse", code: "*444*40*\(bank.code)#", systemImage: "key.fill", flow: .direct)
        let register = BankAction(name: "Registrarse", code: "*444*49*\(bank.code)*NUMERO_DE_TARJETA#", systemImage: "person.badge.plus", flow: .direct)
        let remove = BankAction(name: "Eliminar registro", code: "*444*68*\(bank.code)#", systemImage: "person.badge.minus", flow: .direct)
        return [auth, register, remove] + common
    }

    static let common: [BankAction] = [
        .init(name:"Consultar saldo", code:"*444*46#", systemImage:"dollarsign.circle", flow:.direct),
        .init(name:"Últimas operaciones", code:"*444*48#", systemImage:"clock.arrow.circlepath", flow:.direct),
        .init(name:"Transferencia", code:"*444*45#", systemImage:"arrow.left.arrow.right", flow:.transfer),
        .init(name:"Pagar electricidad", code:"*444*41#", systemImage:"bolt.fill", flow:.direct),
        .init(name:"Pagar teléfono", code:"*444*42#", systemImage:"phone.fill", flow:.direct),
        .init(name:"Pagar ONAT", code:"*444*43#", systemImage:"doc.text.fill", flow:.direct),
        .init(name:"Pagar agua", code:"*444*51#", systemImage:"drop.fill", flow:.direct),
        .init(name:"Servicios contratados", code:"*444*52#", systemImage:"list.bullet.rectangle", flow:.direct),
        .init(name:"Recargar saldo móvil", code:"*444*54#", systemImage:"iphone.gen3", flow:.mobileRecharge),
        .init(name:"Amortizar crédito", code:"*444*55#", systemImage:"creditcard.fill", flow:.direct),
        .init(name:"Consultar ONAT", code:"*444*56*RC05#", systemImage:"doc.text.magnifyingglass", flow:.direct),
        .init(name:"Todas las cuentas", code:"*444*58#", systemImage:"rectangle.stack.fill", flow:.direct),
        .init(name:"Recargar Nauta", code:"*444*59#", systemImage:"wifi", flow:.direct),
        .init(name:"Asociar tarjeta", code:"*444*60#", systemImage:"creditcard.and.123", flow:.direct),
        .init(name:"Cambiar límites", code:"*444*61#", systemImage:"slider.horizontal.3", flow:.direct),
        .init(name:"Consultar límites", code:"*444*62#", systemImage:"gauge", flow:.direct),
        .init(name:"Últimos pagos", code:"*444*63#", systemImage:"receipt", flow:.direct),
        .init(name:"Giro postal", code:"*444*64#", systemImage:"envelope.fill", flow:.direct),
        .init(name:"Consultar giro", code:"*444*65#", systemImage:"envelope.open.fill", flow:.direct),
        .init(name:"Pagar gas", code:"*444*67#", systemImage:"flame.fill", flow:.direct),
        .init(name:"Cambiar PIN", code:"*444*69#", systemImage:"number.square.fill", flow:.direct),
        .init(name:"Desconectarse", code:"*444*70#", systemImage:"rectangle.portrait.and.arrow.right", flow:.direct),
        .init(name:"Consultar créditos", code:"*444*72#", systemImage:"banknote.fill", flow:.direct),
        .init(name:"Localizar transferencia", code:"*444*73#", systemImage:"magnifyingglass", flow:.direct),
        .init(name:"Reimprimir tarjeta", code:"*444*74#", systemImage:"printer.fill", flow:.direct),
        .init(name:"Cambiar PIN Multibanca", code:"*444*75#", systemImage:"key.fill", flow:.direct),
        .init(name:"Imprimir tarjeta USD", code:"*444*76#", systemImage:"dollarsign.square.fill", flow:.direct),
        .init(name:"Recarga propia", code:"*444*77#", systemImage:"arrow.clockwise.circle.fill", flow:.direct),
        .init(name:"PIN digital", code:"*444*79#", systemImage:"lock.square.fill", flow:.direct)
    ]
}
