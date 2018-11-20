import UIKit

class ThumbnailLayer: CALayer {
    
    var outerBorderColor: UIColor = ThumbnailLayer.default.borderColor
    var outerBorderWidth: CGFloat = ThumbnailLayer.default.borderWidth
    var thumnailColor: UIColor = ThumbnailLayer.default.thumnailColor
    var thumnailImage: UIImage?
    
    var isHighlight = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        if let thumnailImage = thumnailImage {
            self.contents = thumnailImage.ciImage
            self.borderColor = self.outerBorderColor.cgColor
            self.borderWidth = self.outerBorderWidth
            self.cornerRadius = thumnailImage.size.height / 2.0
        } else {
            self.drawPath(in: ctx)
        }
    }
    
    private func drawPath(in ctx: CGContext) {
        var thumbFrame = self.bounds.insetBy(dx: outerBorderWidth / 2.0, dy:  outerBorderWidth / 2.0)
        thumbFrame = isHighlight ? thumbFrame.insetBy(dx: 4, dy: 4) : thumbFrame
        let path = UIBezierPath.init(roundedRect: thumbFrame, cornerRadius: thumbFrame.size.height / 2.0)
        ctx.setFillColor(self.thumnailColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
    }
}

fileprivate extension ThumbnailLayer {
    
    private struct `default` {
        private init() {}
        static let borderColor: UIColor = UIColor.blue
        static let borderWidth: CGFloat = 2
        static let thumnailColor: UIColor = UIColor.white
    }
}
