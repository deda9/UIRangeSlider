import UIKit

class TrackLayer: CALayer {
    
    var offColor: UIColor = TrackLayer.default.offColor
    var onColor: UIColor = TrackLayer.default.offColor
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 100.0
    
    override func draw(in ctx: CGContext) {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height * 0.5)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(offColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        ctx.setFillColor(onColor.cgColor)
        let rect = CGRect.init(x: minValue, y: 0, width: maxValue, height: bounds.height)
        ctx.fill(rect)
    }
}

fileprivate extension TrackLayer {
    private struct `default` {
        private init() {}
        static let offColor: UIColor = UIColor.gray
        static let onColor: UIColor = UIColor.blue
        
    }
}
