//
//  NewsStoryTableViewCell.swift
//  StocksApps
//
//  Created by Bryan on 2021/12/22.
//

import UIKit
import SDWebImage

class NewsStoryTableViewCell: UITableViewCell {
    
    static let identifier = "NewsStoryTableViewCell"
    static let preferredHeight : CGFloat = 140
    
    struct ViewModel {
        let source:String
        let headline:String
        let dateString :String
        let imageUrl:URL?
        
        init(model:NewsStory){
            self.source = model.source
            self.headline = model.headline
            self.dateString = String.string(from: model.datetime)
            self.imageUrl = URL(string: model.image )
        }
    }
    
    //Source
    private let sourceLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    //headline
    private let headlineLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    //Date
    private let dateLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    //Image
    private let storyImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds  = true
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = nil
        addSubviews(sourceLabel,headlineLabel,dateLabel,storyImageView)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize:CGFloat = contentView.height / 1.4
        storyImageView.frame = CGRect(x: contentView.width - imageSize - 10, y: (contentView.height - imageSize) / 2, width: imageSize, height: imageSize)
        
        let availableWidth:CGFloat = contentView.width - separatorInset.left - imageSize - 12
        //设置separatorInset属性（iOS7 之后加入的），这个属性定义了分割线到左右边界的距离
        dateLabel.frame = CGRect(x: separatorInset.left, y: contentView.height - 40 , width: availableWidth, height: 40)
        sourceLabel.sizeToFit()
        sourceLabel.frame = CGRect(x: separatorInset.left, y: 4, width: availableWidth, height: sourceLabel.height)
        headlineLabel.frame = CGRect(x: separatorInset.left, y: sourceLabel.bottom + 5 , width: availableWidth, height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    public func configure(with viewModel:ViewModel){
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
//        storyImageView.setImage(with: viewModel.imageUrl)
        storyImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        
    }
}
