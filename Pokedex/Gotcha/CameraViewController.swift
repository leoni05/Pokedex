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
    
    private let hudContainerView = UIView()
    private let centerHUDImageView = UIImageView()
    private let leftTopHUDImageView = UIImageView()
    private let rightTopHUDImageView = UIImageView()
    private let leftBottomHUDImageView = UIImageView()
    private let rightBottomHUDImageView = UIImageView()

    private let loadingView = UIView()
    private let loadingContainerView = UIView()
    private let loadingLabel = UILabel()
    private let loadingImageView = UIImageView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(cameraView)
        
        self.view.addSubview(hudContainerView)
        
        centerHUDImageView.image = UIImage(named: "camera.center")
        centerHUDImageView.contentMode = .scaleAspectFit
        hudContainerView.addSubview(centerHUDImageView)
        
        leftTopHUDImageView.image = UIImage(named: "camera.left.top")
        leftTopHUDImageView.contentMode = .scaleAspectFit
        hudContainerView.addSubview(leftTopHUDImageView)
        
        rightTopHUDImageView.image = UIImage(named: "camera.right.top")
        rightTopHUDImageView.contentMode = .scaleAspectFit
        hudContainerView.addSubview(rightTopHUDImageView)
        
        leftBottomHUDImageView.image = UIImage(named: "camera.left.bottom")
        leftBottomHUDImageView.contentMode = .scaleAspectFit
        hudContainerView.addSubview(leftBottomHUDImageView)
        
        rightBottomHUDImageView.image = UIImage(named: "camera.right.bottom")
        rightBottomHUDImageView.contentMode = .scaleAspectFit
        hudContainerView.addSubview(rightBottomHUDImageView)
        
        loadingView.backgroundColor = .white
        self.view.addSubview(loadingView)
        
        loadingView.addSubview(loadingContainerView)
        
        loadingImageView.image = UIImage(named: "pokeball.loading")
        loadingImageView.contentMode = .scaleAspectFit
        loadingContainerView.addSubview(loadingImageView)
        
        loadingLabel.textColor = .wineRed
        loadingLabel.font = UIFont(name: "Galmuri11-Bold", size: 14)
        loadingLabel.text = "LOADING"
        loadingContainerView.addSubview(loadingLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(_:)), name: AVCaptureSession.didStartRunningNotification, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.pin.all()
        
        hudContainerView.pin.horizontally().bottom().top(MainUpperView.topInset)
        centerHUDImageView.pin.center().width(92).height(52)
        leftTopHUDImageView.pin.left(16).top(16).size(50)
        rightTopHUDImageView.pin.right(16).top(16).size(50)
        leftBottomHUDImageView.pin.left(16).bottom(16).size(50)
        rightBottomHUDImageView.pin.right(16).bottom(16).size(50)
        
        loadingView.pin.all()
        loadingImageView.pin.top().left().size(60)
        loadingLabel.pin.below(of: loadingImageView, aligned: .center).marginTop(6).sizeToFit()
        loadingContainerView.pin.center().wrapContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
            if granted {
                self?.startCamera()
            } else {
                DispatchQueue.main.async {
                    let alertVC = AlertViewController()
                    alertVC.alertType = .confirm
                    alertVC.titleText = "카메라 접근 권한"
                    alertVC.contentText = "사진 촬영을 위해 카메라 접근 권한이 필요합니다.\n설정 화면으로 이동하시겠습니까?"
                    alertVC.delegate = self
                    self?.present(alertVC, animated: true)
                }
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession?.stopRunning()
    }
}

// MARK: - Private Extensions

private extension CameraViewController {
    func startCamera() {
        setLoadingView(visible: true)
        DispatchQueue.global(qos: .userInitiated).async {
            if self.captureSession == nil {
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
    
    @objc func didReceiveNotification(_ notification: Notification) {
        if notification.name == AVCaptureSession.didStartRunningNotification {
            setLoadingView(visible: false)
        }
    }
    
    func setLoadingView(visible: Bool) {
        DispatchQueue.main.async {
            if visible {
                self.loadingView.isHidden = false
                self.loadingView.alpha = 1.0
                
                let kAnimationKey = "rotation"
                if self.loadingImageView.layer.animation(forKey: kAnimationKey) == nil {
                    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rotationAnimation.fromValue = 0.0
                    rotationAnimation.toValue = Double.pi * 2
                    rotationAnimation.duration = 1.0
                    rotationAnimation.repeatCount = .infinity
                    self.loadingImageView.layer.add(rotationAnimation, forKey: kAnimationKey)
                }
            }
            else {
                UIView.animate(withDuration: 0.7, animations: {
                    self.loadingView.alpha = 0.0
                }, completion: { _ in
                    self.loadingView.isHidden = true
                    self.loadingImageView.layer.removeAllAnimations()
                })
            }
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

// MARK: - AlertViewControllerDelegate

extension CameraViewController: AlertViewControllerDelegate {
    func buttonPressed(buttonType: AlertButtonType) {
        if buttonType == .ok {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
}
