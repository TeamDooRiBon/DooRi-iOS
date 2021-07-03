//
//  PagerTabSampleViewController.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/02.
//

import UIKit
import SnapKit

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
        style.titleActiveColor = Colors.pointOrange.color
        style.barColor = Colors.pointOrange.color
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

class PagerTabSampleComponent2ViewController: UITableViewController, PageComponentProtocol {
    var pageTitle: String {
        "component2"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel()
        cell.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        label.text = "IndexPath : \(indexPath)"
        cell.backgroundColor = .systemTeal
        return cell
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
