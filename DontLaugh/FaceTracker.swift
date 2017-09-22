//
//  FaceTracker.swift
//  DontLaugh
//
//  Created by William Vuong on 9/21/17.
//  Copyright © 2017 William Vuong. All rights reserved.
//


import Foundation
import GoogleMVDataOutput

protocol FaceTrackerDelegate {
    
    func updateEyesLocation(leftEyePosition: CGPoint?, rightEyePosition: CGPoint?) -> Void
    
}

class FaceTracker: NSObject, GMVOutputTrackerDelegate {
    
    var lastLeftEyePosition: CGPoint?
    var lastRightEyePosition: CGPoint?
    var delegate: FaceTrackerDelegate?
    
    func dataOutput(_ dataOutput: GMVDataOutput!, detectedFeature feature: GMVFeature!) {
        
    }
    
    func dataOutput(_ dataOutput: GMVDataOutput!, updateFocusing feature: GMVFeature!, forResultSet features: [GMVFeature]!) {
        if let face = feature as? GMVFaceFeature {
            var leftEyePosition: CGPoint?
            var rightEyePosition: CGPoint?
            if face.hasLeftEyePosition {
                leftEyePosition = face.leftEyePosition
            }
            if face.hasRightEyePosition {
                rightEyePosition = face.rightEyePosition
            }
            self.delegate?.updateEyesLocation(leftEyePosition: leftEyePosition, rightEyePosition: rightEyePosition)
        } else {
            self.delegate?.updateEyesLocation(leftEyePosition: nil, rightEyePosition: nil)
        }
    }
    
    
    func dataOutput(_ dataOutput: GMVDataOutput!, updateMissing features: [GMVFeature]!) {
        self.delegate?.updateEyesLocation(leftEyePosition: nil, rightEyePosition: nil)
    }
    
    func dataOutputCompleted(withFocusingFeature dataOutput: GMVDataOutput!) {

    }
    
}
