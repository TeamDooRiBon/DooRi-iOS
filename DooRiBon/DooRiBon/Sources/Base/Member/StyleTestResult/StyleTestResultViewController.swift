//
//  StyleTestResultViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/12.
//

import UIKit

class StyleTestResultViewController: UIViewController {

    //MARK:- IBOutlet
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    var name: String = ""
    var imgURL: String = ""
    var style: String = ""
    var buttonText: String = "여행 그룹으로 이동"
    var mainOrMember = false
    var fromOurView = false
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        imageSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Function
    
    func configureUI() {
        nameLabel.text = "\(name)님은"
        let title = style.replacingOccurrences(of: " ", with: "\n")
        styleLabel.text = title
        backButton.setTitle(buttonText, for: .normal)
    }
    
    func imageSet() {
        guard let url = URL(string: imgURL) else { return }
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
        backButton.layer.applyShadow(color: Colors.gray_black2.color, alpha: 0.08, x: 0, y: 1, blur: 10, spread: 2)
    }
    
    func backTwoWhenNavigationControllerUsed(){
        let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3 ], animated: true)
    }
    
    //MARK:- IBAction
    
    @IBAction func backButtonClicked(_ sender: Any) {
        if fromOurView {
            let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
        } else {
            if mainOrMember {
                performSegue(withIdentifier: "unwindVC1", sender: self)
            }
            else {
                backTwoWhenNavigationControllerUsed()
            }
        }
    }
}
