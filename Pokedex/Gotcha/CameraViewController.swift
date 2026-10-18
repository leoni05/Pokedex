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
    func captureFinished(cameraVC: CameraViewController, gotchaResult: GotchaResult?)
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
    private var gotchaResult: GotchaResult? = nil
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
        if self.gotchaResult != nil {
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
                        self.delegate?.captureFinished(cameraVC: self, gotchaResult: self.gotchaResult)
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
    
    func generateImageData(sampleBuffer: CMSampleBuffer) throws -> (Data, Data) {
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            throw GotchaError.imageGenerate
        }
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0),
              let thumbnailData = createThumbnailData(imageData: imageData, maxPixelSize: 200.0) else {
            throw GotchaError.imageGenerate
        }
        return (imageData, thumbnailData)
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
        
    func saveImageToDirectory(imageData: Data, thumbnailData: Data, imageName: String) throws {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first else {
            throw GotchaError.documentsDirectory
        }
        let fileUrl = documentsDirectory.appendingPathComponent(imageName, conformingTo: .jpeg)
        let thumbnailFileUrl = documentsDirectory.appendingPathComponent(imageName + "_thumbnail", conformingTo: .jpeg)
        do {
            try imageData.write(to: fileUrl)
            try thumbnailData.write(to: thumbnailFileUrl)
        } catch {
            print("Failed to save image data: \(error)")
            throw error
        }
    }
    
    func uploadImageToFirebase(imageData: Data, imageName: String) async throws -> (URL, StorageReference) {
        let firebaseReference = Storage.storage().reference().child("images/\(imageName)")
        do {
            let _ = try await firebaseReference.putDataAsync(imageData)
            let url = try await firebaseReference.downloadURL()
            return (url, firebaseReference)
        }
        catch {
            throw error
        }
    }
    
    func processingImageURL(imageURL: URL, imageName: String, storageReference: StorageReference) async throws {
        guard let plistURL = Bundle.main.url(forResource: "Keys", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: plistURL),
              let openAIKey = dict["OpenAI"] as? String,
              let apiURL = URL(string: "https://api.openai.com/v1/responses")
        else {
            throw GotchaError.openAI
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "model": "gpt-6-astra",
            "input": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "input_text",
                            "text": """
                                # 역할
                                당신은 포켓몬 이미지 식별 AI입니다.

                                사용자가 제공한 이미지를 분석하여 이미지에 실제로 표현된
                                포켓몬을 식별하고, 결과를 지정된 숫자 문자열로 반환합니다.

                                # 점수 규칙
                                1. 첫 번째 숫자는 이미지 식별 결과의 전반적인 신뢰도 점수입니다.
                                2. 점수는 0부터 500 사이의 정수입니다.
                                3. 포켓몬의 식별 가능 여부, 이미지의 선명도, 가림 정도,
                                   시각적 특징의 명확성을 종합적으로 고려합니다.
                                4. 식별 근거가 충분하고 결과가 명확할수록 높은 점수를 부여합니다.
                                5. 식별 가능한 포켓몬이 없으면 반드시 0을 반환합니다.
                                6. 점수는 실제 측정값이 아닌 AI의 판단에 따른 점수입니다.

                                # 포켓몬 식별 규칙
                                1. 이미지에 등장하는 식별 가능한 모든 포켓몬을 식별합니다.
                                2. 포켓몬의 외형, 색상, 신체 구조, 얼굴, 무늬 및 특징적인
                                   부위를 종합적으로 분석합니다.
                                3. 공식 포켓몬 전국도감 데이터를 기준으로 식별합니다.
                                4. 도감 번호는 공식 전국도감 번호를 사용합니다.
                                5. 메가진화, 리전폼, 다른 폼, 의상 및 색이 다른 포켓몬도
                                   식별 가능한 경우 해당 포켓몬으로 식별합니다.
                                6. 서로 다른 폼이 동일한 전국도감 번호를 사용한다면
                                   해당 번호는 한 번만 반환합니다.
                                7. 같은 포켓몬이 이미지에 여러 번 등장하더라도
                                   전국도감 번호는 중복해서 반환하지 않습니다.
                                8. 포켓몬이 아닌 물체, 팬아트, 장난감, 인형, 카드 및
                                   게임 화면도 식별 대상이 될 수 있습니다.
                                9. 포켓몬의 외형이 충분히 확인되지 않거나 식별 근거가
                                   부족하면 해당 포켓몬을 결과에 포함하지 않습니다.
                                10. 도감 번호를 확신할 수 없는 경우 임의로 추측하지 않습니다.
                                11. 포켓몬 번호는 식별 신뢰도가 높은 순서대로 반환합니다.

                                # 출력 형식
                                1. 반드시 숫자와 콤마(,)로 구성된 문자열 하나만 반환합니다.
                                2. 공백, 설명, JSON, Markdown 및 기타 문자는 출력하지 않습니다.
                                3. 첫 번째 숫자는 0~500 사이의 이미지 식별 점수입니다.
                                4. 두 번째 숫자부터는 식별된 포켓몬의 전국도감 번호입니다.
                                5. 식별된 포켓몬 번호는 중복 없이 반환합니다.
                                6. 식별 가능한 포켓몬이 없으면 정확히 "0"만 반환합니다.

                                # 출력 예시
                                4마리 식별:
                                450,1,4,7,25

                                포켓몬이 없는 이미지:
                                0
                                """
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
            throw GotchaError.openAI
        }
        request.httpBody = jsonData
        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let outputArray = result["output"] as? [[String: Any]],
              let messageOutput = outputArray.first(where: { ($0["type"] as? String) == "message" }),
              let contentArray = messageOutput["content"] as? [[String: Any]],
              let textContent = contentArray.first(where: { ($0["type"] as? String) == "output_text" }),
              let responseText = textContent["text"] as? String
        else {
            throw GotchaError.openAI
        }
        var resultText = responseText
        resultText = resultText.components(separatedBy: [" ", "\n"]).joined()
        let gotchaResult = makeGotchaResult(resultText: resultText)
        
        do {
            try CoreDataManager.shared.savePhoto(captureDate: Date(), name: imageName, gotchaResult: gotchaResult)
            try await storageReference.delete()
            CoreDataManager.shared.needReloadGalleryVC = true
            CoreDataManager.shared.needReloadPokedexVC = true
            
            Pokedex.shared.acquireScore(score: gotchaResult.resultScore)
            Pokedex.shared.setListedPokemons()
            self.gotchaResult = gotchaResult
        }
        catch {
            throw error
        }
    }
    
    func makeGotchaResult(resultText: String) -> GotchaResult {
        var gotchaResult = GotchaResult()
        let resultArray = resultText.components(separatedBy: ",")
        if resultArray.count > 0 {
            gotchaResult.resultScore = Int(resultArray[0]) ?? 0
            gotchaResult.resultPokemonNumbers = []
            gotchaResult.pokemonNumberSet = []
            
            for idx in 1..<resultArray.count {
                if let pokedexNumber = Int(resultArray[idx]) {
                    if pokedexNumber <= Pokedex.totalNumber
                        && gotchaResult.pokemonNumberSet.contains(pokedexNumber) == false {
                        gotchaResult.resultPokemonNumbers.append(pokedexNumber)
                        gotchaResult.pokemonNumberSet.insert(pokedexNumber)
                    }
                }
            }
        }
        return gotchaResult
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
        
        Task {
            let imageName = "\(UUID().uuidString)-\(String(Date().timeIntervalSince1970)).jpg"
            let retryCount = 5
            
            for attemptNum in 0..<retryCount {
                do {
                    let (imageData, thumbnailData) = try generateImageData(sampleBuffer: sampleBuffer)
                    try saveImageToDirectory(imageData: imageData, thumbnailData: thumbnailData, imageName: imageName)
                    let (url, storageReference) = try await uploadImageToFirebase(imageData: imageData, imageName: imageName)
                    try await processingImageURL(imageURL: url, imageName: imageName, storageReference: storageReference)
                    break
                }
                catch {
                    print("Capture error \(error)")
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    if attemptNum+1 >= retryCount {
                        self.showFileUploadErrorAlert()
                        self.showGuideView(text: "아깝다! 조금만 더 하면 됐는데!")
                    }
                }
            }
        }
    }
}

// MARK: - AlertViewControllerDelegate

extension CameraViewController: AlertViewControllerDelegate {
    func buttonPressed(buttonType: AlertButtonType, tag: Int?) {
        if buttonType == .ok {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
}
