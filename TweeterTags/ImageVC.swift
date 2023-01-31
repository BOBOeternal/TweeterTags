//
//  ImageVC.swift
//  TweeterTags
//
//  Created by Joy on 2022/12/3.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {

    
    // Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView?.contentSize = imageView.frame.size
            scrollView?.minimumZoomScale = min(0.2, scrollView.bounds.width / scrollView.contentSize.width)
            scrollView?.maximumZoomScale = 1.0
            scrollView?.zoomScale = scrollView.maximumZoomScale
        }
    }
    
    // Private properties and methods
    private var imageView = UIImageView()
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageView.frame.size)
            //scrollView?.contentSize = imageView.frame.size
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            Task(priority: .userInitiated) {
                let imageData = try? Data(contentsOf: url)
                try await Task.sleep(nanoseconds: 2) // Simulate slow network
                await MainActor.run {
                    spinner?.stopAnimating()
                    image = imageData != nil ? UIImage(data: imageData!) : nil
                }
            }
        }
    }
    
    // Open API
    open var  imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                getImage()
                fetchImage()
            }
        }
    }
    
    // VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil { fetchImage() }
    }
    
    // Protocol UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    
    
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView?.maximumZoomScale = 1
//        scrollView?.minimumZoomScale = min(0.1, scrollView.bounds.size.width / scrollView.contentSize.width)
//        scrollView?.zoomScale = scrollView.maximumZoomScale
//        getImage()
//    }
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if image == nil {
//            getImage()
//        }
//    }
//
    private func getImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if  url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
//
//    @objc func doubleTapped() {
//        if scrollView.zoomScale == 1 {
//            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: imageView.bounds.origin), animated: true)
//        } else {
//            scrollView.setZoomScale(1, animated: true)
//        }
//    }
//
//    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
//        var zoomRect = CGRect.zero
//        zoomRect.size.height = imageView.frame.size.height / scale
//        zoomRect.size.width  = imageView.frame.size.width  / scale
//        let newCenter = scrollView.convert(center, from: imageView)
//        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
//        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
//        return zoomRect
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.addSubview(imageView)
//        getImage()
//
//        let width = imageView.frame.width
//        let height = imageView.frame.height
//
//        self.scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }

}
