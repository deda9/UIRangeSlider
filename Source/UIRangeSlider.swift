import UIKit

class UIRangeSlider: UIControl {
    
    var trackLayer: TrackLayer = TrackLayer()
    
    var minTextLayer: TextLayer = TextLayer()
    var maxTextLayer: TextLayer = TextLayer()
    
    var minThumbLayer: ThumbnailLayer = ThumbnailLayer()
    var maxThumbLayer: ThumbnailLayer = ThumbnailLayer()
    
    var trackHeight: CGFloat = 6.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var minValue: CGFloat = 0.0 {
        didSet {
            trackLayer.minValue = self.minValue
            updateLayerFrames()
        }
    }
    
    var maxValue: CGFloat = 100.0 {
        didSet {
            trackLayer.maxValue = self.maxValue
            updateLayerFrames()
        }
    }
    
    var offColor: UIColor = UIColor.gray {
        didSet {
            trackLayer.offColor = self.offColor
            updateLayerFrames()
        }
    }
    
    var onColor: UIColor = UIColor.white {
        didSet {
            trackLayer.onColor = self.onColor
            updateLayerFrames()
        }
    }
    
    var thumnailImage: UIImage? = nil {
        didSet {
            minThumbLayer.thumnailImage = self.thumnailImage
            maxThumbLayer.thumnailImage = self.thumnailImage
            updateLayerFrames()
        }
    }
    
    var thumnailColor: UIColor = UIColor.blue {
        didSet {
            minThumbLayer.thumnailColor = self.thumnailColor
            maxThumbLayer.thumnailColor = self.thumnailColor
            updateLayerFrames()
        }
    }
    
    var thumnailSize: CGFloat = 40.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var textFontSize: CGFloat = 14.0 {
        didSet {
            self.minTextLayer.textFontSize = self.textFontSize
            self.maxTextLayer.textFontSize = self.textFontSize
            updateLayerFrames()
        }
    }
    
    var textFontColor: UIColor = UIColor.blue {
        didSet {
            self.minTextLayer.textFontColor = self.textFontColor
            self.maxTextLayer.textFontColor = self.textFontColor
            updateLayerFrames()
        }
    }
    
    var thumnailBorderColor: UIColor = UIColor.white {
        didSet {
            self.minThumbLayer.outerBorderColor = self.thumnailBorderColor
            self.maxThumbLayer.outerBorderColor = self.thumnailBorderColor
            updateLayerFrames()
        }
    }
    
    var thumnailBorderWidth: CGFloat = 2 {
        didSet {
            self.minThumbLayer.outerBorderWidth = self.thumnailBorderWidth
            self.maxThumbLayer.outerBorderWidth = self.thumnailBorderWidth
            updateLayerFrames()
        }
    }
    
    lazy var currentMinValue: CGFloat = minValue
    lazy var currentMaxValue: CGFloat = maxValue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
        updateLayerFrames()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        if minThumbLayer.frame.contains(location) {
            self.minThumbLayer.isHighlight = true
            return true
        } else if maxThumbLayer.frame.contains(location) {
            self.maxThumbLayer.isHighlight = true
            return true
        }
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let currentValue = location.x / self.bounds.width
        if currentValue >= 0.0 || currentValue <= 1.0 {
            if maxThumbLayer.isHighlight {
                self.currentMaxValue = max(min(max(currentValue, 0), 1) * self.maxValue, currentMinValue * self.maxValue)
            } else if minThumbLayer.isHighlight {
                self.currentMinValue = min(min(max(currentValue, 0), 1), self.currentMaxValue / self.maxValue)
            }
        }
        updateLayerFrames()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.maxThumbLayer.isHighlight = false
        self.minThumbLayer.isHighlight = false
    }
}

fileprivate extension UIRangeSlider {
    func setupLayers() {
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.minTextLayer)
        self.layer.addSublayer(self.maxTextLayer)
        self.layer.addSublayer(self.maxThumbLayer)
        self.layer.addSublayer(self.minThumbLayer)
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        func updateTrackLayerFrame() {
            let tempFrame = CGRect(x: 0,
                                   y: (self.bounds.height - self.trackHeight / 2),
                                   width: self.bounds.width,
                                   height: self.trackHeight)
            self.trackLayer.frame = tempFrame
            self.trackLayer.setNeedsDisplay()
        }
        
        func updateMinThumnailFrame() {
            let xValue = self.bounds.width * self.currentMinValue - self.thumnailSize / 2
            let tempFrame =  CGRect(x: xValue,
                                    y: (self.bounds.height - self.thumnailSize / 2),
                                    width: self.thumnailSize,
                                    height: self.thumnailSize)
            self.minThumbLayer.frame = tempFrame
            self.minThumbLayer.setNeedsDisplay()
        }
        
        func updateMaxThumnailFrame() {
            let xValue = self.bounds.width * self.currentMaxValue / self.maxValue - self.thumnailSize / 2
            let tempFrame =  CGRect(x: xValue,
                                    y: (self.bounds.height - self.thumnailSize / 2),
                                    width: self.thumnailSize,
                                    height: self.thumnailSize)
            self.maxThumbLayer.frame = tempFrame
            self.maxThumbLayer.setNeedsDisplay()
        }
        
        func updateMinTextFrame() {
            self.minTextLayer.frame = self.minThumbLayer.frame
            self.minTextLayer.frame.origin.y -= 16
            self.minTextLayer.string = "\(Int(self.currentMinValue * self.maxValue))"
            self.minTextLayer.setNeedsDisplay()
        }
        
        func updateMaxTextFrame() {
            self.maxTextLayer.frame = self.maxThumbLayer.frame
            self.maxTextLayer.frame.origin.y -= 16
            self.maxTextLayer.string = "\(Int(self.currentMaxValue))"
            self.maxTextLayer.setNeedsDisplay()
        }
        
        updateTrackLayerFrame()
        updateMinThumnailFrame()
        updateMaxThumnailFrame()
        updateMinTextFrame()
        updateMaxTextFrame()
        CATransaction.commit()
    }
}
