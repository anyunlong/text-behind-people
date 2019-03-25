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
    
    private var playerLayer = AVPlayerLayer()
    
    private var playerItem: AVPlayerItem?
    
    private var playerItemOutput = AVPlayerItemVideoOutput()
    
//    lazy var image: UIImage? = {
//        return UIImage(named: "vn2")
//    }()
    
    lazy var imageView: UIImageView = UIImageView()
    
    lazy var textBackground: TextBackground = {
        let view = TextBackground()
        return view
    }()
    
//    lazy var flyLayer: FlyLayer = {
//        let layer = FlyLayer()
//        layer.backgroundColor = UIColor.red.cgColor
//        return layer
//    }()
    
    private lazy var flyView: FlyView = {
        
        let dataSource = ArrayDataSource(data: [1, 2, 3, 4], identifierMapper: { (_int, _what) -> String in
            return "\(0)"
        })
        let viewSource = ClosureViewSource(viewUpdater: { (UILabel, _, _int) in
            <#code#>
        })
//        let sizeSource = SizeSource()
        
        let provider = BasicProvider(dataSource: dataSource,
                                     viewSource: viewSource,
                                     sizeSource: sizeSource)
        return FlyView(provider: provider)
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
        view.layer.addSublayer(playerLayer)
        player.play()
        
//        imageView.image = image
        view.addSubview(imageView)

        view.addSubview(textBackground)
//        textBackground.layer.addSublayer(flyLayer)
        
        textBackground.addSubview(flyView)

        CADisplayLink.init(target: self, selector: #selector(displayLinkCallback)).add(to: RunLoop.main, forMode: .default)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = view.bounds
        
        imageView.frame = view.bounds
        textBackground.frame = view.bounds
//        flyLayer.frame = textBackground.bounds
        flyView.frame = textBackground.bounds
    }
    
    @objc private func displayLinkCallback() {
        
        guard let _playerItem = playerItem,
            let plxelBuffer = playerItemOutput.copyPixelBuffer(forItemTime: _playerItem.currentTime(), itemTimeForDisplay: nil) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: plxelBuffer)
        if let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) {
            
            updateMask(image: cgImage)
//            flyLayer.update()
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
