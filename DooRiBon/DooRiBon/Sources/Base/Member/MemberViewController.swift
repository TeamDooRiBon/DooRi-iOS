//
//  PagerTabSampleViewController.swift
//  PagerTab
//
//  Created by 민 on 2021/07/06.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var pagerTab: PagerTab!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let vc1 = UIStoryboard(name: "WeStoryboard", bundle: nil).instantiateViewController(identifier: "WeViewController") as? WeViewController else { return }
        guard let vc2 = UIStoryboard(name: "TakeLookStoryboard", bundle: nil).instantiateViewController(identifier: "TakeLookViewController") as? TakeLookViewController else { return }
        
        let viewControllers: [PageComponentProtocol] = [
            vc1,
            vc2
        ]
       
        var style = PagerTab.Style.default
        style.titleActiveColor = UIColor.orange
        style.barColor = UIColor.orange
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

