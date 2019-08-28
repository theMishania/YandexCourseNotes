//
//  PreviewViewController.swift
//  Notes
//
//  Created by Мишаня on 16/07/2019.
//  Copyright © 2019 Мишаня. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var imageViews = [UIImageView]()
    public  var indexOffset: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        view.backgroundColor = .black
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        self.scrollView = scrollView
        scrollView.backgroundColor = .black
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        scrollView.leftAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leftAnchor, multiplier: 0).isActive = true
        scrollView.rightAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.rightAnchor, multiplier: 0).isActive = true
        
        for imageView in imageViews{
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
        for (index, imageView) in imageViews.enumerated(){
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: scrollView.frame.width * CGFloat(indexOffset), y: 0),
                                              size: scrollView.frame.size),
                                       animated: false)
    }
    
    public func fillImageViewsArray(withImages images: [UIImage]){
        for image in images{
            let imageView = UIImageView(image: image)
            self.imageViews.append(imageView)
        }
    }
    
    public convenience init(images: [UIImage], indexOffset: Int){
        self.init()
        fillImageViewsArray(withImages: images)
        self.indexOffset = indexOffset
        self.hidesBottomBarWhenPushed = true
    }

}
