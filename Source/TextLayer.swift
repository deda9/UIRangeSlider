import UIKit

class TextLayer: CATextLayer {
    
    var textFontSize: CGFloat = TextLayer.default.fontSize
    var textFontColor: UIColor = TextLayer.default.fontColor
    var textAlignment: CATextLayerAlignmentMode = TextLayer.default.textAlignment
    
    override func draw(in ctx: CGContext) {
        self.fontSize = self.textFontSize
        self.foregroundColor = self.textFontColor.cgColor
        self.alignmentMode = self.textAlignment
        super.draw(in: ctx)
    }
}

fileprivate extension TextLayer {
    
    private struct `default` {
        private init() {}
        static let fontSize: CGFloat = 14
        static let fontColor: UIColor = UIColor.blue
        static let textAlignment: CATextLayerAlignmentMode  = .center
    }
}
