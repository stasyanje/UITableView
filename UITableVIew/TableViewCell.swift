//
//  TableViewCell.swift
//  UITableVIew
//
//  Created by Admin on 07.02.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    private let titleAttributes: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 16)]
    
    var backView = UIView()
    var cellImageView = UIImageView()
    var topTitleLabel = UILabel()
    var bottomTitleLabel = UILabel()
    
    var topTitleHeight: CGFloat = 0
    var bottomTitleHeight: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        topTitleLabel.numberOfLines = 0
        bottomTitleLabel.numberOfLines = 0
        
        cellImageView.backgroundColor = .red
        cellImageView.layer.cornerRadius = 5.0
        cellImageView.clipsToBounds = true
        backView.backgroundColor = UIColor(white: 246.0/255, alpha: 1.0)
        backView.layer.cornerRadius = 5.0
        
        contentView.addSubview(backView)
        contentView.addSubview(cellImageView)
        contentView.addSubview(topTitleLabel)
        contentView.addSubview(bottomTitleLabel)
    }
    
    func set(topTitle: String, bottomTitle: String, imageURL: URL) {
        let attributedTitle = NSAttributedString(string: topTitle, attributes: titleAttributes)
        let bottomAttributedTitle = NSAttributedString(string: bottomTitle, attributes: titleAttributes)
        topTitleLabel.attributedText = attributedTitle
        bottomTitleLabel.attributedText = bottomAttributedTitle
        let imageRes = ImageResource(downloadURL: imageURL)
        cellImageView.kf.setImage(with: imageRes)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    func prepareLayout(topTitle: String, bottomTitle: String) {
        let screenWidth = UIScreen.main.bounds.width
        let cellHeight = screenWidth * 0.4
        let imageWidth = cellHeight - 10 * 2
        
        let rightTextWidth = screenWidth - imageWidth - 10 - 10 - 10
        
        let attributes = titleAttributes
        let topAttributedString = NSAttributedString(string: topTitle,
                                                  attributes: attributes)
        let topTitleRect = topAttributedString.boundingRect(with: CGSize(width: rightTextWidth,
                                                                  height: .greatestFiniteMagnitude),
                                                     options: .usesLineFragmentOrigin, context: nil)
        topTitleHeight = topTitleRect.height
        
        let bottomAttributedString = NSAttributedString(string: bottomTitle,
                                                        attributes: attributes)
        bottomTitleHeight = bottomAttributedString.boundingRect(with: CGSize(width: screenWidth - 10 * 2,
                                                                             height: .greatestFiniteMagnitude),
                                                                options: .usesLineFragmentOrigin, context: nil).height
        
        frame.size.width = screenWidth
        let textedHeight = topTitleHeight + 10 + 10
        let topSectionHeight = textedHeight < cellHeight ? cellHeight : textedHeight
        let height = topSectionHeight + 10 + bottomTitleHeight + 10
        frame.size.height = height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenWidth = UIScreen.main.bounds.width
        let imageWidth = screenWidth * 0.4 - 10 * 2
        
        backView.frame.origin.x = 5
        backView.frame.origin.y = 5
        backView.frame.size.width = screenWidth - 5 * 2
        backView.frame.size.height = bounds.height - 5 * 2
        
        cellImageView.frame.origin.x = 10
        cellImageView.frame.origin.y = 10
        cellImageView.frame.size.width = imageWidth
        cellImageView.frame.size.height = imageWidth
        
        topTitleLabel.frame.size.width = screenWidth - imageWidth - 10 - 10 - 10
        topTitleLabel.frame.size.height = topTitleHeight
        topTitleLabel.frame.origin.x = imageWidth + 10 + 10
        topTitleLabel.sizeToFit()
        topTitleLabel.frame.origin.y = 10
        
        bottomTitleLabel.frame.size.width = screenWidth - 10 * 2
        bottomTitleLabel.frame.origin.x = 10
        let bottomTitleOriginY = max(cellImageView.frame.maxY, topTitleLabel.frame.maxY)
        bottomTitleLabel.frame.origin.y = bottomTitleOriginY + 10
        bottomTitleLabel.sizeToFit()
    }
}
