//
//  PagerTabSampleViewController.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/02.
//

import UIKit

class PagerTabSampleViewController: UIViewController {
    @IBOutlet private weak var pagerTab: PagerTab!

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewControllers: [PageComponentProtocol] = [
            PagerTabSampleComponent1ViewController(),
            PagerTabSampleComponent2ViewController(),
            PagerTabSampleComponent3ViewController()
        ]
        var style = PagerTab.Style.default
        style.titleActiveColor = .mainOrange
        style.barColor = .mainOrange
        pagerTab.setup(self, viewControllers: viewControllers, style: style)
    }
}

class PagerTabSampleComponent1ViewController: UIViewController, PageComponentProtocol {
    var pageTitle: String {
        "component1"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}

class PagerTabSampleComponent2ViewController: UIViewController, PageComponentProtocol {
    var pageTitle: String {
        "component2"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
    }
}

class PagerTabSampleComponent3ViewController: UIViewController, PageComponentProtocol {
    var pageTitle: String {
        "component3"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
    }
}
