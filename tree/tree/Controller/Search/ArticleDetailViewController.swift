//
//  ArticleDetailViewController.swift
//  tree
//
//  Created by hyerikim on 22/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: ArticleImage!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var floatingButton = UIButton()
    var articleDetail: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestureRecognizer()
        setArticleData()
    }

    override func viewWillAppear(_ animated: Bool) {
        createFloatingButton()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeFloatingButton()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func getImageFromCache(articleUrl: String?) {
        guard let imageUrl = articleUrl else { 
            imageView.isHidden = true
            return 
        }
        if let imageFromCache = imageChache.object(forKey: imageUrl as AnyObject) as? UIImage {
            self.imageView.image = imageFromCache
        } else {
            self.imageView.loadImageUrl(articleUrl: articleUrl!)
        }
    }
    
    private func registerGestureRecognizer() {
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
    private func setArticleData() {
        titleLabel.text = articleDetail?.title
        dateLabel.text = articleDetail?.date
        contentLabel.text = articleDetail?.body
        getImageFromCache(articleUrl: articleDetail?.image ?? nil)
        if articleDetail?.author != nil && articleDetail?.author?.isEmpty == false {
            if let author = articleDetail?.author?[0].name {
                self.authorLabel.text = author
            }
        }
    }
    
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton.backgroundColor = .black
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.addTarget(self, action: #selector(translateButtonOnClick), for: .touchUpInside)
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.floatingButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.floatingButton.trailingAnchor, constant: 25),
                    keyWindow.bottomAnchor.constraint(equalTo: self.floatingButton.bottomAnchor, constant: 40),
                    self.floatingButton.widthAnchor.constraint(equalToConstant: 50),
                    self.floatingButton.heightAnchor.constraint(equalToConstant: 50)])
            }
        }
    }
    
    private func removeFloatingButton() {
        if floatingButton.superview != nil {
            DispatchQueue.main.async {
                self.floatingButton.removeFromSuperview()
            }
        }
    }
    
    @objc private func translateButtonOnClick() {
        //reload view
    }
    
    @objc private func imageTapped() {
        guard let articleImage = imageView.image else { return }
        guard let articleViewer = self.storyboard?.instantiateViewController(withIdentifier: "ArticleImageViewController") as? ArticleImageViewController else { return }
        articleViewer.articleImage = articleImage
        self.present(articleViewer, animated: false, completion: nil)
    }
}
