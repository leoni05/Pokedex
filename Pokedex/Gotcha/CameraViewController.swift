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

protocol CameraViewControllerDelegate: AnyObject {
    func captureFinished(cameraVC: CameraViewController, resultText: String)
}

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
    
    private let starLabels: Array<UILabel> = [UILabel(), UILabel(), UILabel()]
    private var resultText: String? = nil
    weak var delegate: CameraViewControllerDelegate? = nil
    private var timerForShaking: Timer? = nil
    
    // MARK: - Life Cycle
    
    deinit {
        print("CameraViewController deinit")
    }
    
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
        
        starLabels[0].font = UIFont(name: "Galmuri11-Bold", size: 19)
        starLabels[1].font = UIFont(name: "Galmuri11-Bold", size: 25)
        starLabels[2].font = UIFont(name: "Galmuri11-Bold", size: 22)
        for idx in 0..<starLabels.count {
            starLabels[idx].text = "★"
            starLabels[idx].textColor = .wineRed
            starLabels[idx].sizeToFit()
            starLabels[idx].isHidden = true
            starLabels[idx].alpha = 0.0
            loadingView.addSubview(starLabels[idx])
        }
        
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
                    self?.showGuideView(text: "NO CAMERA PERMISSION")
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
        showSpinningGuideView(text: "LOADING")
        DispatchQueue.global(qos: .userInitiated).async {
            if self.captureSession == nil {
                let captureSession = AVCaptureSession()
                captureSession.beginConfiguration()
                
                if captureSession.canSetSessionPreset(.high) == true {
                    captureSession.sessionPreset = .high
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
                videoOutput.connections.first?.videoRotationAngle = 90.0
                self.videoOutput = videoOutput
                
                captureSession.commitConfiguration()
                captureSession.startRunning()
                self.captureSession = captureSession
            }
        }
    }
    
    @objc func didReceiveNotification(_ notification: Notification) {
        if notification.name == AVCaptureSession.didStartRunningNotification {
            hideGuideView()
        }
    }
    
    func hideGuideView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7, animations: {
                self.loadingView.alpha = 0.0
            }, completion: { _ in
                self.loadingView.isHidden = true
                self.timerForShaking?.invalidate()
                self.timerForShaking = nil
                self.loadingImageView.layer.removeAllAnimations()
            })
        }
    }
    
    func showGuideView(text: String? = nil, appearAnimated: Bool = false) {
        DispatchQueue.main.async {
            if let text = text {
                self.loadingLabel.text = text
                self.loadingLabel.pin.below(of: self.loadingImageView, aligned: .center).marginTop(6).sizeToFit()
                self.loadingContainerView.pin.center().wrapContent()
            }
            self.loadingView.isHidden = false
            if appearAnimated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.loadingView.alpha = 1.0
                })
            }
            else {
                self.loadingView.alpha = 1.0
            }
            self.timerForShaking?.invalidate()
            self.timerForShaking = nil
            self.loadingImageView.layer.removeAllAnimations()
        }
    }
    
    func showSpinningGuideView(text: String? = nil, appearAnimated: Bool = false) {
        DispatchQueue.main.async {
            if let text = text {
                self.loadingLabel.text = text
                self.loadingLabel.pin.below(of: self.loadingImageView, aligned: .center).marginTop(6).sizeToFit()
                self.loadingContainerView.pin.center().wrapContent()
            }
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
            if self.loadingImageView.layer.animation(forKey: kAnimationKey) == nil {
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.fromValue = 0.0
                rotationAnimation.toValue = Double.pi * 2
                rotationAnimation.duration = 1.0
                rotationAnimation.repeatCount = .infinity
                self.loadingImageView.layer.add(rotationAnimation, forKey: kAnimationKey)
            }
        }
    }
    
    func showCapturingGuideView(text: String? = nil, appearAnimated: Bool = false) {
        DispatchQueue.main.async {
            if let text = text {
                self.loadingLabel.text = text
                self.loadingLabel.pin.below(of: self.loadingImageView, aligned: .center).marginTop(6).sizeToFit()
                self.loadingContainerView.pin.center().wrapContent()
            }
            self.loadingView.isHidden = false
            if appearAnimated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.loadingView.alpha = 1.0
                })
            }
            else {
                self.loadingView.alpha = 1.0
            }
            self.timerForShaking = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                                        selector: #selector(self.shakePokeball(_:)),
                                                        userInfo: nil, repeats: true)
        }
    }
    
    @objc func shakePokeball(_ timer: Timer) {
        if self.resultText != nil {
            timer.invalidate()
            timerForShaking = nil
            for idx in 0..<starLabels.count {
                starLabels[idx].pin.center(to: loadingImageView.anchor.center)
                starLabels[idx].alpha = 0.0
                starLabels[idx].isHidden = false
            }
            starLabels[0].transform = CGAffineTransform(rotationAngle: -6.0)
            starLabels[1].transform = CGAffineTransform(rotationAngle: -1.5)
            starLabels[2].transform = CGAffineTransform(rotationAngle: 4.4)
            
            UIView.animate(withDuration: 0.8, delay: 0.0, animations: {
                self.starLabels[0].pin.above(of: self.loadingImageView, aligned: .center).marginRight(30)
                self.starLabels[1].pin.above(of: self.loadingImageView, aligned: .center).marginBottom(5)
                self.starLabels[2].pin.above(of: self.loadingImageView, aligned: .center).marginLeft(30)
                for idx in 0..<self.starLabels.count {
                    self.starLabels[idx].transform = .identity
                }
            })
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                for idx in 0..<self.starLabels.count {
                    self.starLabels[idx].alpha = 1.0
                }
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                    for idx in 0..<self.starLabels.count {
                        self.starLabels[idx].alpha = 0.0
                    }
                }, completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.delegate?.captureFinished(cameraVC: self, resultText: self.resultText ?? "")
                    }
                })
            })
            return
        }
        
        self.loadingImageView.layer.removeAllAnimations()
        let initX = loadingImageView.center.x
        let diffX: CGFloat = 6.0
        let ballRadius: CGFloat = 24.0
        let diffAngle: CGFloat = diffX / ballRadius
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            CATransaction.begin()
            let positionXAnim2 = CABasicAnimation(keyPath: "position.x")
            positionXAnim2.fromValue = initX
            positionXAnim2.toValue = initX + diffX
            
            let rotationAnim2 = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnim2.fromValue = 0.0
            rotationAnim2.toValue = diffAngle
            
            let animGroup2 = CAAnimationGroup()
            animGroup2.animations = [positionXAnim2, rotationAnim2]
            animGroup2.duration = 0.08
            animGroup2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animGroup2.autoreverses = true
            
            self.loadingImageView.layer.add(animGroup2, forKey: "animGroup")
            CATransaction.commit()
        })
        
        let positionXAnim1 = CABasicAnimation(keyPath: "position.x")
        positionXAnim1.fromValue = initX
        positionXAnim1.toValue = initX - diffX
        
        let rotationAnim1 = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim1.fromValue = 0.0
        rotationAnim1.toValue = -diffAngle
        
        let animGroup1 = CAAnimationGroup()
        animGroup1.animations = [positionXAnim1, rotationAnim1]
        animGroup1.duration = 0.08
        animGroup1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animGroup1.autoreverses = true
        
        self.loadingImageView.layer.add(animGroup1, forKey: "animGroup")
        CATransaction.commit()
    }
    
    func showFileUploadErrorAlert() {
        DispatchQueue.main.async {
            let alertVC = AlertViewController()
            alertVC.delegate = nil
            alertVC.alertType = .alert
            alertVC.titleText = "사진 업로드 오류"
            alertVC.contentText = "사진 업로드 중에 오류가 발생했습니다.\n잠시 후 시도해 주세요."
            self.present(alertVC, animated: true)
        }
    }
    
    func createThumbnailData(imageData: Data, maxPixelSize: CGFloat) -> Data? {
        let imageSourceOptions = [
            kCGImageSourceShouldCache: false ] as CFDictionary
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize ] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions),
              let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        let resultImage = UIImage(cgImage: downsampledImage)
        return resultImage.jpegData(compressionQuality: 1.0)
    }
        
    func saveImageToDirectory(imageData: Data, thumbnailData: Data, imageName: String, completion: () -> Void) {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectory.appendingPathComponent(imageName, conformingTo: .jpeg)
        let thumbnailFileUrl = documentsDirectory.appendingPathComponent(imageName + "_thumbnail", conformingTo: .jpeg)
        do {
            try imageData.write(to: fileUrl)
            try thumbnailData.write(to: thumbnailFileUrl)
            completion()
        } catch {
            print("Failed to save image data: \(error)")
            self.showFileUploadErrorAlert()
            self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
        }
    }
    
    func uploadImageToFirebase(imageData: Data, imageName: String, completion: @escaping (URL) -> Void) {
        let firebaseReference = Storage.storage().reference().child("images/\(imageName)")
        firebaseReference.putData(imageData, metadata: nil) { metaData, error in
            if metaData == nil {
                self.showFileUploadErrorAlert()
                self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
                return
            }
            firebaseReference.downloadURL { url, error in
                guard let url = url else {
                    self.showFileUploadErrorAlert()
                    self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
                    return
                }
                completion(url)
            }
        }
    }
    
    func processingImageURL(imageURL: URL, imageName: String) {
        guard let plistURL = Bundle.main.url(forResource: "Keys", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: plistURL),
              let openAIKey = dict["OpenAI"] as? String,
              let apiURL = URL(string: "https://api.openai.com/v1/responses")
        else {
            self.showFileUploadErrorAlert()
            self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
            return
        }
        
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
                            "text": "Please analyze this image and send me the result string with several numbers separated by commas. First number is the score of this image. The score ranges from 0 to 500. After that, the following are national pokedex numbers of the pokemons in this image without duplication."
                        ],
                        [
                            "type": "input_image",
                            "image_url": imageURL.absoluteString
                        ]
                    ]
                ]
            ]
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            self.showFileUploadErrorAlert()
            self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
            return
        }
        request.httpBody = jsonData
        Task {
            guard let (data, _) = try? await URLSession.shared.data(for: request),
                  let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let output = (result["output"] as? [Any])?.first as? [String : Any],
                  let content = (output["content"] as? [Any])?.first as? [String : Any],
                  let responseText = content["text"] as? String
            else {
                self.showFileUploadErrorAlert()
                self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
                return
            }
            var resultText = responseText
            resultText = resultText.components(separatedBy: [" ", "\n"]).joined()
            CoreDataManager.shared.savePhoto(captureDate: Date(), name: imageName, resultString: resultText) {
                self.resultText = resultText
            }
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
        self.showCapturingGuideView(text: "지우는 몬스터볼을 썼다!", appearAnimated: true)
        
        self.captureSession?.stopRunning()
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            self.showFileUploadErrorAlert()
            self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
            return
        }
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0),
              let thumbnailData = createThumbnailData(imageData: imageData, maxPixelSize: 200.0) else {
            self.showFileUploadErrorAlert()
            self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
            return
        }
        let imageName = "\(UUID().uuidString)-\(String(Date().timeIntervalSince1970)).jpg"
        
        saveImageToDirectory(imageData: imageData, thumbnailData: thumbnailData, imageName: imageName) {
            uploadImageToFirebase(imageData: imageData, imageName: imageName) { url in
                self.processingImageURL(imageURL: url, imageName: imageName)
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
