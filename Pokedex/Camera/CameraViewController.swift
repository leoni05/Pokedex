//
//  CameraViewController.swift
//  Pokedex
//
//  Created by leoni05 on 6/3/25.
//

import Foundation
import UIKit
import PinLayout
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - Properties

    private let cameraView = UIView()
    private var captureSession: AVCaptureSession? = nil
    private var backCamera: AVCaptureDevice? = nil
    private var backCameraDeviceInput: AVCaptureDeviceInput? = nil
    private var previewLayer: AVCaptureVideoPreviewLayer? = nil
    private var videoOutput: AVCaptureVideoDataOutput? = nil
    private var needToTakePicture = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(cameraView)
        setCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.pin.all()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession?.stopRunning()
    }
}

// MARK: - Private Extensions

private extension CameraViewController {
    func setCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            let captureSession = AVCaptureSession()
            captureSession.beginConfiguration()
            
            if captureSession.canSetSessionPreset(.photo) == true {
                captureSession.sessionPreset = .photo
            }
            captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                self.backCamera = backCamera
                if let backCameraDeviceInput = try? AVCaptureDeviceInput(device: backCamera) {
                    self.backCameraDeviceInput = backCameraDeviceInput
                    if captureSession.canAddInput(backCameraDeviceInput) {
                        captureSession.addInput(backCameraDeviceInput)
                    }
                }
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer = previewLayer
            DispatchQueue.main.async {
                previewLayer.frame = self.cameraView.frame
                self.cameraView.layer.insertSublayer(previewLayer, at: 0)
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            self.videoOutput = videoOutput

            captureSession.commitConfiguration()
            captureSession.startRunning()
            self.captureSession = captureSession
        }
    }
}

// MARK: - Extensions

extension CameraViewController {
    func takePicture() {
        needToTakePicture = true
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if needToTakePicture == false {
            return
        }
        if let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let ciImage = CIImage(cvImageBuffer: cvBuffer)
            let uiImage = UIImage(ciImage: ciImage)
            needToTakePicture = false
            print("hihi uiImage \(uiImage)")
        }
    }
}
