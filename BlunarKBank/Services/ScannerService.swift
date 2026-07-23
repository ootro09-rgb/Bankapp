import AVFoundation
import Vision
import UIKit

final class ScannerService: NSObject, ObservableObject {
    let session = AVCaptureSession()
    @Published var permissionDenied = false
    @Published var result: String?
    private let queue = DispatchQueue(label: "blunarkbank.camera")
    private var lastVisionRun = Date.distantPast
    private var locked = false

    func start() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async { self?.permissionDenied = !granted }
            guard granted else { return }
            self?.configureAndRun()
        }
    }

    func stop() { queue.async { if self.session.isRunning { self.session.stopRunning() } } }

    private func configureAndRun() {
        queue.async {
            guard self.session.inputs.isEmpty else { self.session.startRunning(); return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            guard let camera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: camera),
                  self.session.canAddInput(input) else { return }
            self.session.addInput(input)

            let metadata = AVCaptureMetadataOutput()
            if self.session.canAddOutput(metadata) {
                self.session.addOutput(metadata)
                metadata.setMetadataObjectsDelegate(self, queue: self.queue)
                metadata.metadataObjectTypes = [.qr]
            }

            let video = AVCaptureVideoDataOutput()
            video.alwaysDiscardsLateVideoFrames = true
            video.setSampleBufferDelegate(self, queue: self.queue)
            if self.session.canAddOutput(video) { self.session.addOutput(video) }
            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    private func accept(payload: String) {
        guard !locked, let card = CardNumberExtractor.extract(from: payload) else { return }
        locked = true
        DispatchQueue.main.async {
            UIPasteboard.general.string = card
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.result = card
        }
        stop()
    }
}

extension ScannerService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for object in metadataObjects {
            if let qr = object as? AVMetadataMachineReadableCodeObject, let value = qr.stringValue { accept(payload: value) }
        }
    }
}

extension ScannerService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard Date().timeIntervalSince(lastVisionRun) > 0.45,
              let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        lastVisionRun = Date()
        let request = VNRecognizeTextRequest { [weak self] request, _ in
            let text = (request.results as? [VNRecognizedTextObservation])?
                .compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ") ?? ""
            self?.accept(payload: text)
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        request.minimumTextHeight = 0.025
        try? VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .right).perform([request])
    }
}
