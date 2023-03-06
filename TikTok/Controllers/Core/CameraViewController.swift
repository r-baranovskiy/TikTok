import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    
    private var videoCaptureDevice: AVCaptureDevice?
    
    private let captureOutput = AVCaptureMovieFileOutput()
    
    private var capturePreviewLayer: AVCaptureVideoPreviewLayer? = nil
    
    private var previewLayer: AVPlayerLayer?
    
    private var recordedVideoURL: URL?
    
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    
    private let recordButton = RecordButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 100
        recordButton.frame = CGRect(
            x: (view.width - size) / 2,
            y: view.height - view.safeAreaInsets.bottom - size - 5,
            width: size, height: size)
    }
    
    // MARK: - Behaviour
    
    private func setUpView() {
        view.addSubview(cameraView )
        view.addSubview(recordButton)
        view.backgroundColor = .systemYellow
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self,
            action: #selector(didTapClose))
        
        recordButton.addTarget(
            self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            captureOutput.stopRecording()
            recordButton.toggle(for: .notRecording)
        } else {
            guard var url = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            if #available(iOS 16.0, *) {
                url.append(path: "video.mov")
            } else {
                url.appendPathComponent("video.mov")
            }
            
            recordButton.toggle(for: .recording)
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    @objc private func didTapClose() {
        navigationItem.rightBarButtonItem = nil
        recordButton.isHidden = false
        
        if previewLayer != nil {
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
        } else {
            captureSession.stopRunning()
            tabBarController?.tabBar.isHidden = false
            tabBarController?.selectedIndex = 0
        }
    }
    
    @objc private func didTapNext() {
        
    }
    
    // MARK: - Camera action
    
    private func setUpCamera() {
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        
        captureSession.sessionPreset = .hd1280x720
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(
                title: "Woops",
                message: "Something went wrong when recording your video",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        recordedVideoURL = outputFileURL
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next", style: .done, target: self,
            action: #selector(didTapNext))
        
        let player = AVPlayer(url: outputFileURL)
        previewLayer = AVPlayerLayer(player: player)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = cameraView.bounds
        
        guard let previewLayer = previewLayer else { return }
        recordButton.isHidden = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.player?.play()
    }
}
