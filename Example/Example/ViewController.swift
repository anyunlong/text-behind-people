//
//  ViewController.swift
//  Example
//
//  Created by Yunlong An on 2019/3/24.
//  Copyright © 2019 Yunlong An. All rights reserved.
//

import UIKit
import Vision
import AVFoundation
import CollectionKit

class ViewController: UIViewController {
    
    private var displayLinkCallCount: Int = 0
    
    private var playerLayer = AVPlayerLayer()
    
    private var playerItem: AVPlayerItem?
    
    private var playerItemOutput = AVPlayerItemVideoOutput()
    
    lazy var textBackground: TextBackground = {
        let view = TextBackground()
        return view
    }()
    
    private lazy var flyView: FlyView = {
        return FlyView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
            return
        }
        
        playerItem = AVPlayerItem(url: videoURL)
        playerItem!.add(playerItemOutput)
        let player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        view.layer.addSublayer(playerLayer)
        player.play()

        view.addSubview(textBackground)
        textBackground.addSubview(flyView)

        CADisplayLink.init(target: self, selector: #selector(displayLinkCallback)).add(to: RunLoop.main, forMode: .default)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = view.bounds
        textBackground.frame = playerLayer.frame
        flyView.frame = textBackground.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        flyView.startFly()
    }
    
    @objc private func displayLinkCallback() {
        
//        displayLinkCallCount = displayLinkCallCount + 1
        
        guard let _playerItem = playerItem else {
                return
        }
        
        if let range = _playerItem.seekableTimeRanges.first as? CMTimeRange {
            let compare = CMTimeCompare(_playerItem.currentTime(), range.duration)
            if compare == 0 {
                return
            }
        }
        
        guard let plxelBuffer = playerItemOutput.copyPixelBuffer(forItemTime: _playerItem.currentTime(), itemTimeForDisplay: nil) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: plxelBuffer)
        if let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) {
            updateMask(image: cgImage)
        }
    }
    
    private func updateMask(image: CGImage) {
        
        let landmarksRequest = VNDetectFaceLandmarksRequest { (request, error) in
            
            if let _request = request as? VNDetectFaceLandmarksRequest,
                let observations = _request.results as? [VNFaceObservation] {
                
                // 所有人的 脸部轮廓点
                var facesPoints = [Array<Any>]()
                // 遍历所有人
                for observation in observations {
                    
                    // 人脸矩形框
                    let boundingBox = observation.boundingBox
                    
                    // 取出每个人的脸部轮廓点
                    if let landmarks2D = observation.landmarks,
                        let faceContour = landmarks2D.faceContour {
                        
                        var realPoints = [CGPoint]()
                        for normalizedPoint in faceContour.normalizedPoints {
                            
                            let showSize = self.view.frame.size
                            let point = self.convert(normalizedPoint: normalizedPoint, boundingBox: boundingBox, showSize: showSize)
                            realPoints.append(point)
                        }
                        facesPoints.append(realPoints)
                    }
                }
                
                let shapeLayer = CAShapeLayer()
                let bPath = UIBezierPath.init(rect: self.view.bounds)
                for facePoints in facesPoints {
                    
                    if let _facePoints = facePoints as? [CGPoint] {
                        
                        let facePath = CGMutablePath()
                        facePath.addLines(between: _facePoints)
                        //                        facePath.addLines(between: [CGPoint(x: 0, y: 0),
                        //                                                    CGPoint(x: 100, y: 0),
                        //                                                    CGPoint(x: 100, y: 100),
                        //                                                    CGPoint(x: 0, y: 100)])
                        bPath.append(UIBezierPath.init(cgPath: facePath))
                    }
                }
                shapeLayer.path = bPath.cgPath
                self.textBackground.layer.mask = shapeLayer
            }
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        try? requestHandler.perform([landmarksRequest])
    }
    
    /// 坐标转换
    private func convert(normalizedPoint: CGPoint, boundingBox: CGRect, showSize: CGSize) -> CGPoint {
        
        let frameWidth = boundingBox.width * showSize.width
        let frameHeight = boundingBox.height * showSize.height
        let x = boundingBox.origin.x * showSize.width + normalizedPoint.x * frameWidth
        let y = showSize.height - (boundingBox.origin.y * showSize.height + normalizedPoint.y * frameHeight)
        return CGPoint(x: x, y: y)
    }
    
//    /// 画线
//    private func drawLines(points: [Array<Any>], image: UIImage) -> UIImage {
//
//    }
}
