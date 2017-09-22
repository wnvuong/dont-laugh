//
//  FirstViewController.swift
//  DontLaugh
//
//  Created by William Vuong on 9/21/17.
//  Copyright © 2017 William Vuong. All rights reserved.
//

import AVFoundation
import UIKit
import GoogleMobileVision
import GoogleMVDataOutput

class FirstViewController: UIViewController, GMVMultiDataOutputDelegate, FaceTrackerDelegate {
    
    @IBOutlet var previewView: UIView!
    @IBOutlet var gameStatus: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var dataOutput: GMVDataOutput?
    
    func updateEyesLocation(leftEyePosition: CGPoint?, rightEyePosition: CGPoint?) {
        if leftEyePosition != nil && rightEyePosition != nil {
            self.gameStatus.text = "READY TO PLAY"
            self.gameStatus.backgroundColor = UIColor.init(red: 0, green: 165/255, blue: 0, alpha: 0.65)
        } else {
            self.gameStatus.text = "FACE THE CAMERA"
            self.gameStatus.backgroundColor = UIColor.red.withAlphaComponent(0.65)

        }
    }
    
    public func dataOutput(_ dataOutput: GMVDataOutput!, trackerFor feature: GMVFeature!) -> GMVOutputTrackerDelegate! {
        let tracker: FaceTracker = FaceTracker()
        tracker.delegate = self
        return tracker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession = AVCaptureSession()
            self.captureSession?.addInput(input)
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.videoPreviewLayer?.frame = view.layer.bounds
            self.previewView.layer.addSublayer(videoPreviewLayer!)
            
            setupGMVDataOutput()
            
            self.captureSession?.startRunning()

        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGMVDataOutput() {
        let options: [AnyHashable: Any] = [
            GMVDetectorFaceTrackingEnabled: NSNumber(booleanLiteral: true),
            GMVDetectorFaceMode: NSNumber(integerLiteral: GMVDetectorFaceModeOption.fastMode.rawValue),
            GMVDetectorFaceLandmarkType: NSNumber(integerLiteral: GMVDetectorFaceLandmark.all.rawValue),
            GMVDetectorFaceClassificationType: NSNumber(integerLiteral: GMVDetectorFaceClassification.all.rawValue),
            GMVDetectorFaceMinSize: NSNumber(floatLiteral: 0.35)
        ]
        
        let detector: GMVDetector = GMVDetector(ofType: GMVDetectorTypeFace, options: options)
        
        self.dataOutput = GMVLargestFaceFocusingDataOutput(detector: detector)
        let tracker: FaceTracker = FaceTracker()
        tracker.delegate = self
        (self.dataOutput as! GMVLargestFaceFocusingDataOutput).trackerDelegate = tracker
        if (self.captureSession?.canAddOutput(self.dataOutput))! {
            self.captureSession?.addOutput(self.dataOutput)
        } else {
            print("Failed to setup video output")
            return;
        }
    }
}
