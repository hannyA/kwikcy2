//
//  INCameraPreviewView.swift
//  PopIn
//
//  Created by Hanny Aly on 8/10/16.
//  Copyright © 2016 Aly LLC. All rights reserved.
//

import Foundation

class INCameraPreviewView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return (self.layer as! AVCaptureVideoPreviewLayer).session
        }
        set (session) {
            (self.layer as! AVCaptureVideoPreviewLayer).session = session
        }
    }
    
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
//    init(frame: CGRect, layer: AVCaptureVideoPreviewLayer) {
//       
//        videoPreviewLayer = layer
//        super.init(frame: frame)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

//    var session: AVCaptureSession? {
//        get {
//            return videoPreviewLayer.session
//        }
//        set {
//            videoPreviewLayer.session = newValue
//        }
//    }
    
}
