//
//  StyleTestResultViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/12.
//

import UIKit
import SnapKit

class StyleTestResultViewController: UIViewController {

    //MARK:- IBOutlet
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSet()
        shadowSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Function
    
    func imageSet() {
        guard let url = URL(string: "https://cdn.cocoacasts.com/cc00ceb0c6bff0d536f25454d50223875d5c79f1/above-the-clouds.jpg") else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.resultImageView.image = image.resized(to: CGSize(width: UIScreen.main.bounds.width, height: image.size.height))
                    }
                }
            }
        }
    }
    
    func shadowSet() {
        backButton.layer.applyShadow(color: Colors.black2.color, alpha: 0.08, x: 0, y: 1, blur: 10, spread: 2)
    }
    
}

//MARK:- Extension

extension UIImage {
    public func resized(to target: CGSize) -> UIImage? {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let newSize = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
