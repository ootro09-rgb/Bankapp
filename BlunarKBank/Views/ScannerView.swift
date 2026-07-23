import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        context.coordinator.layer = layer
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) { context.coordinator.layer?.frame = uiView.bounds }
    func makeCoordinator() -> Coordinator { Coordinator() }
    final class Coordinator { var layer: AVCaptureVideoPreviewLayer? }
}

struct ScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scanner = ScannerService()

    var body: some View {
        ZStack {
            CameraPreview(session: scanner.session).ignoresSafeArea()
            Color.black.opacity(0.25).ignoresSafeArea()
            VStack {
                HStack {
                    Button { dismiss() } label: { Image(systemName: "xmark").font(.title2).padding().background(.ultraThinMaterial, in: Circle()) }
                    Spacer()
                }.padding()
                Spacer()
                Image(systemName: "viewfinder.rectangular")
                    .font(.system(size: 190, weight: .ultraLight))
                    .foregroundStyle(.white)
                    .symbolEffect(.pulse)
                Text("Apunta al QR o al número de la tarjeta")
                    .font(.headline).padding(.top, 20)
                Text("Se copiarán únicamente los 16 dígitos de la tarjeta")
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
            }
        }
        .task { scanner.start() }
        .onDisappear { scanner.stop() }
        .alert("Tarjeta copiada", isPresented: Binding(get: { scanner.result != nil }, set: { if !$0 { scanner.result = nil } })) {
            Button("Listo") { dismiss() }
        } message: {
            Text("•••• •••• •••• \(scanner.result?.suffix(4) ?? "")")
        }
    }
}
