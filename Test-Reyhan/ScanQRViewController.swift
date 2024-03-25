//
//  ScanQRViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit
import AVKit

class ScanQRViewController: UIViewController, CustomTransitionEnabledVC{
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
    }
    
    private enum Constants {
      static let alertTitle = "Scanning is not supported"
      static let alertMessage = "Your device does not support scanning a code from an item. Please use a device with a camera."
      static let alertButtonTitle = "OK"
    }

    // MARK: - set up camera

    func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            session.addInput(input)
            session.addOutput(output)
            
            output.metadataObjectTypes = [.qr]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            
            view.layer.addSublayer(previewLayer)
            
            session.startRunning()
        } catch {

            showAlert()
            print(error)
        }
    }

    // MARK: - Alert

    func showAlert() {
        let alert = UIAlertController(title: Constants.alertTitle,
                                      message: Constants.alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle,
                                      style: .default))
        present(alert, animated: true)
    }
}

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  metadataObject.type == .qr,
                  let stringValue = metadataObject.stringValue else { return }
        
        print(stringValue)
    }
}
