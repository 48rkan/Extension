//  PinterestLayout.swift
//  Giphy
//  Created by Erkan Emir on 16.05.23.

import UIKit

protocol PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    
    var delegate: PinterestLayoutDelegate!
    
    var numberOfColumns = 1
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0
    
    private var width: CGFloat {
        get {
            return CGRectGetWidth(collectionView!.bounds)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        if cache.isEmpty {
            let columntWidth = width / CGFloat(numberOfColumns)
            
            var xOffsets = [CGFloat]()
            
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columntWidth)
            }
            
            var yOffests = [CGFloat](repeating: 0, count: numberOfColumns)
            
            var column = 0
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = NSIndexPath(item: item, section: 0)
                
                let height = delegate.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath)
                
                let frame = CGRect(x: xOffsets[column], y: yOffests[column], width: columntWidth, height: height)
                
                //?
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                
                yOffests[column] = yOffests[column] + height
                
                if column >= (numberOfColumns - 1) {
                    column = 0
                } else {
                    column += 1
                }
                
            }
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }

}


class CustomCollectionView: UICollectionView {
    
    let layout = UICollectionViewFlowLayout()
    
    init(scroll: UICollectionView.ScrollDirection,
         spacing: CGFloat) {
        super.init(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = scroll
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        configureCollectionView()
    }
        
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
    
    func configureCollectionView() {
        self.showsVerticalScrollIndicator   = false
        self.showsHorizontalScrollIndicator = false
    }
}

class CustomLabel: UILabel {
    
    init(text: String,textColor: UIColor,
         hexCode: String? = nil ,
         size: CGFloat,font: String = "Helvetica Neue") {
        super.init(frame: .zero)
        
        if let hexCode = hexCode {
            self.textColor = UIColor(hexString: hexCode)
        } else {
            self.textColor = textColor
        }
        
        self.text = text
        self.font = UIFont(name: font, size: size)
        textAlignment = .center
        numberOfLines = 0
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
}

class CustomTextField: UITextField {
    
    init(placeholder: String,
         fontName: String   = "Poppins-SemiBold",
         size: CGFloat      = 14,
         textColor: UIColor = .white,
         secure: Bool       = false) {
        super.init(frame: .zero)
        
        self.textColor = textColor
        self.font = UIFont(name: fontName, size: size)
                
        self.borderStyle = .none
        self.isSecureTextEntry = secure
        
        self.attributedPlaceholder = NSMutableAttributedString(
            string: placeholder ,
            attributes:
                [.foregroundColor: UIColor(white: 1, alpha: 0.4) ,
                 .font: font ?? UIFont()
                ])
        
        
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 10)
        leftView = spacer
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
}

//custom Button

class CustomButton: UIButton {
    
    //MARK: - Lifecycle
    init(title     : String,
         titleColor: UIColor,
         font      : String  = "Poppins-Bold",
         size      : CGFloat = 16 ) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont(name: font, size: size)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
}

// ses elave etmek ucun

class SoundHandler {
    
    static var player: AVAudioPlayer?

    static func playSound(name: String, type: String) {
        guard let path = Bundle.main.path(forResource: name,
                                          ofType: type) else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// gif gostermek ucun qisa yol
extension CVarArg {
    func setGifFromURL(imageView: UIImageView,url: URL) {
        imageView.setGifFromURL(url,
                                levelOfIntegrity: .superLowForSlideShow,
                                showLoader: true)
    }
}
