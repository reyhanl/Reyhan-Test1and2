//
//  ScanQRViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit
import AVKit

class ScanQRViewController: UIViewController, CustomTransitionEnabledVC, ScanQRPresenterToViewProtocol{
    
    var presenter: ScanQRViewToPresenterProtocol?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    let session = AVCaptureSession()
    var delegate: ScanQRDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit{
        session.stopRunning()
        delegate = nil
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
            
            DispatchQueue.global().async { [weak self] in
                self?.session.startRunning()
            }
        } catch {
            print(String(describing: error))
        }
    }
    
    func presentErrorAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "OK", style: .destructive))
        self.present(alertController, animated: true)
    }
    
    //MARK: Presenter to view handler
    func result(result: Result<ScanQRSuccessType, Error>) {
        switch result{
        case .success(let type):
            handleSuccess(type: type)
        case .failure(let error):
            switch error{
            case CustomError.unableToScanQRCode:
                presentErrorAlert(title: "QR Code malformed", message: CustomError.unableToScanQRCode.errorDescription ?? "")
            default:
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    func handleSuccess(type: ScanQRSuccessType){
        switch type {
        case .decodeQR(let transaction):
            self.delegate?.successfullyScanQR(transaction: transaction)
        }
    }
}

//MARK: TransitionHandler
extension ScanQRViewController{
    func addPanGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleTransition(_ gestureRecognizer: UIPanGestureRecognizer){
        let translationX = gestureRecognizer.translation(in: view).x
        let percentageInDecimal = -translationX / view.frame.width
        
        switch gestureRecognizer.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            customTransitionDelegate.dismissalTransitionType = .swipeLeft
            dismiss(animated: true)
        case .changed:
            print(percentageInDecimal)
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
        default:
            break
        }
    }

}

//MARK: QRCode handler
extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  metadataObject.type == .qr,
                  let stringValue = metadataObject.stringValue else { return }
        DispatchQueue.main.async {
            self.presenter?.userDidScanQR(qrString: stringValue)
        }
    }
}

enum ScanQRSuccessType{
    case decodeQR(Transaction)
}

struct Transaction{
    var bank: String
    var transactionID: String
    var merchant: String
    var transactionTotal: Double
}

protocol ScanQRDelegate{
    func successfullyScanQR(transaction: Transaction)
}
