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
import FirebaseCore
import FirebaseStorage

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
        self.view.backgroundColor = .white
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
        loadingView.isHidden = true
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
                    self?.setLoadingView(visible: true, text: "NO CAMERA PERMISSION", rotationAnimated: false)
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
        setLoadingView(visible: true, text: "LOADING")
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
    
    func setLoadingView(visible: Bool, text: String? = nil, appearAnimated: Bool = false, rotationAnimated: Bool = true) {
        DispatchQueue.main.async {
            if let text = text {
                self.loadingLabel.text = text
                self.loadingLabel.pin.below(of: self.loadingImageView, aligned: .center).marginTop(6).sizeToFit()
                self.loadingContainerView.pin.center().wrapContent()
            }
            if visible {
                self.loadingView.isHidden = false
                if appearAnimated {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.loadingView.alpha = 1.0
                    })
                }
                else {
                    self.loadingView.alpha = 1.0
                }
                let kAnimationKey = "rotation"
                if rotationAnimated && self.loadingImageView.layer.animation(forKey: kAnimationKey) == nil {
                    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rotationAnimation.fromValue = 0.0
                    rotationAnimation.toValue = Double.pi * 2
                    rotationAnimation.duration = 1.0
                    rotationAnimation.repeatCount = .infinity
                    self.loadingImageView.layer.add(rotationAnimation, forKey: kAnimationKey)
                }
                if rotationAnimated == false {
                    self.loadingImageView.layer.removeAllAnimations()
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
    
    func showFileUploadErrorAlert() {
        DispatchQueue.main.async {
            let alertVC = AlertViewController()
            alertVC.delegate = nil
            alertVC.alertType = .alert
            alertVC.titleText = "카메라 접근 권한"
            alertVC.contentText = "사진 업로드 중에 오류가 발생했습니다.\n잠시 후 시도해 주세요."
            self.present(alertVC, animated: true)
        }
    }
    
    func processingImageURL(imageURL: URL) {
        guard let plistURL = Bundle.main.url(forResource: "Keys", withExtension: "plist") else { return }
        guard let dict = NSDictionary(contentsOf: plistURL) else { return }
        guard let openAIKey = dict["OpenAI"] as? String else { return }
        guard let apiURL = URL(string: "https://api.openai.com/v1/responses") else { return }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "input": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "input_text",
                            "text": "Please analyze this image and send me the result text with several words separated by commas. First word is the score of this image. The score ranges from 0 to 500. After that, the following are pokemon names of the pokemons in this image without duplication."
                        ],
                        [
                            "type": "input_image",
                            "image_url": imageURL.absoluteString
                        ]
                    ]
                ]
            ]
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        request.httpBody = jsonData
        Task {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            if result["error"] == nil { return }
            guard let output = (result["output"] as? [Any])?.first as? [String : Any] else { return }
            guard let content = (output["content"] as? [Any])?.first as? [String : Any] else { return }
            guard let resultText = content["text"] as? String else { return }
            // TODO: - Parsing resultText and showing result
        }
    }
}

// MARK: - Extensions

extension CameraViewController {
    func takePicture() {
        if loadingView.isHidden == true && captureSession?.isRunning == true {
            needToTakePicture = true
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if needToTakePicture == false {
            return
        }
        needToTakePicture = false
        self.setLoadingView(visible: true, text: "SCANNING", appearAnimated: true, rotationAnimated: true)
        self.captureSession?.stopRunning()
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            self.showFileUploadErrorAlert()
            self.setLoadingView(visible: true, text: "ERROR", rotationAnimated: false)
            return
        }
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
            self.showFileUploadErrorAlert()
            self.setLoadingView(visible: true, text: "ERROR", rotationAnimated: false)
            return
        }
        let imageName = "\(UUID().uuidString)-\(String(Date().timeIntervalSince1970)).jpg"
        let firebaseReference = Storage.storage().reference().child("images/\(imageName)")
        
        firebaseReference.putData(imageData, metadata: nil) { metaData, error in
            if metaData == nil {
                self.showFileUploadErrorAlert()
                self.setLoadingView(visible: true, text: "ERROR", rotationAnimated: false)
                return
            }
            firebaseReference.downloadURL { url, error in
                guard let url = url else {
                    self.showFileUploadErrorAlert()
                    self.setLoadingView(visible: true, text: "ERROR", rotationAnimated: false)
                    return
                }
                self.processingImageURL(imageURL: url)
            }
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
