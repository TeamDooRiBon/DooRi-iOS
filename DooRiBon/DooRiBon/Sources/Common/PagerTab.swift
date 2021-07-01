//
//  PagerTab.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/02.
//

import UIKit
import SnapKit

protocol PageComponentProtocol where Self: UIViewController {
    var pageTitle: String { get }
}

class PagerTab: UIView {
    private var style = Style.default

    private var pageContents: [PageContent] = []
    private var currentIndex = 0 {
        didSet {
            pageContents.enumerated().forEach { index, content in
                content.button.isSelected = index == currentIndex
                content.button.titleLabel?.font = index == currentIndex ? style.titleActiveFont : style.titleDefaultFont
            }
        }
    }

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var barBackgroundView: UIView = {
        let view = UIView()
        let lineView = UIView()
        lineView.backgroundColor = style.barDividerColor
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        return view
    }()

    private lazy var barView: UIView = {
        let view = UIView()
        let colorView = UIView()
        colorView.backgroundColor = style.barColor
        colorView.layer.cornerRadius = style.barCornerRadius
        view.addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(style.barHorizontalSpacing / 2)
        }
        return view
    }()

    private let containerView: UIView = UIView()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    private var selectedButton = false

    // MARK: PagerTab을 쓰기 위한 필수 부분. 반드시 setup을 호출해야함.
    func setup(_ target: UIViewController, viewControllers: [PageComponentProtocol], style: Style = .default) {
        self.style = style
        configureUI()

        target.addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: target)

        pageContents = viewControllers.map {
            let button = UIButton()
            button.titleLabel?.font = style.titleDefaultFont
            button.setTitleColor(style.titleDefaultColor, for: .normal)
            button.setTitleColor(style.titleActiveColor, for: .selected)
            button.setTitle($0.pageTitle, for: .normal)
            button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
            return PageContent(button: button, viewController: $0)
        }
        setupPageViewController()
        updatePagerTabButton()
    }

    private func configureUI() {
        addSubview(titleStackView)
        addSubview(barBackgroundView)
        barBackgroundView.addSubview(barView)
        addSubview(containerView)

        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(style.buttonHeight)
        }
        barBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(style.barHeight)
        }
        barView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(barBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self

        if let viewController = pageContents.first?.viewController {
            pageViewController.setViewControllers(
                [viewController],
                direction: .forward,
                animated: false,
                completion: nil)
            currentIndex = 0
        }

        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }

    private func updatePagerTabButton() {
        let barCount = pageContents.count
        pageContents.forEach { content in
            titleStackView.addArrangedSubview(content.button)
        }
        barView.snp.makeConstraints {
            $0.width.equalToSuperview().dividedBy(max(barCount, 1))
        }
    }

    @objc private func selectButton(_ sender: UIButton) {
        guard let index = pageContents.firstIndex(where: { $0.button === sender }),
              index != currentIndex else {
            return
        }

        selectedButton = true
        pageViewController.view.isUserInteractionEnabled = false

        barView.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(CGFloat(index) * barView.frame.width)
        }
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut) {
            self.barBackgroundView.layoutIfNeeded()
        } completion: { _ in
            self.selectedButton = false
            self.pageViewController.view.isUserInteractionEnabled = true
        }

        let content = pageContents[index]
        pageViewController.setViewControllers(
            [content.viewController],
            direction: currentIndex < index ? .forward : .reverse,
            animated: true) { [weak self] _ in
            self?.currentIndex = index
        }
    }
}

extension PagerTab: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageContents.firstIndex(where: { $0.viewController === viewController }) else {
            return nil
        }
        let afterIndex = index + 1
        if afterIndex < pageContents.count {
            return pageContents[afterIndex].viewController
        }
        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageContents.firstIndex(where: { $0.viewController === viewController }) else {
            return nil
        }
        let beforeIndex = index - 1
        if beforeIndex >= 0 {
            return pageContents[beforeIndex].viewController
        }
        return nil
    }
}

extension PagerTab: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = pageContents.firstIndex(where: { $0.viewController === viewController }) else {
            return
        }
        currentIndex = index
    }
}

extension PagerTab: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !selectedButton else { return }
        let offsetX = scrollView.contentOffset.x
        let percentComplete = (offsetX - pageViewController.view.frame.width) / pageViewController.view.frame.width
        barView.snp.updateConstraints {
            $0.leading.equalToSuperview().inset((percentComplete + CGFloat(currentIndex)) * barView.frame.width)
        }
    }
}

// TODO: color asset이 등록된 이후에 style 수정. 현재는 예시로 구현되어있음.
extension PagerTab {
    struct Style {
        var barColor: UIColor
        var barHeight: CGFloat
        var barHorizontalSpacing: CGFloat
        var barCornerRadius: CGFloat
        var barDividerColor: UIColor

        var buttonBackgroundColor: UIColor
        var buttonHeight: CGFloat

        var titleActiveColor: UIColor
        var titleDefaultColor: UIColor
        var titleActiveFont: UIFont
        var titleDefaultFont: UIFont

        static var `default` = Style(
            barColor: .orange,
            barHeight: 3.0,
            barHorizontalSpacing: 10.0,
            barCornerRadius: 2.0,
            barDividerColor: .clear,
            buttonBackgroundColor: .white,
            buttonHeight: 45.0,
            titleActiveColor: .orange,
            titleDefaultColor: .lightGray,
            titleActiveFont: .systemFont(ofSize: 14.0, weight: .bold),
            titleDefaultFont: .systemFont(ofSize: 13.0))
    }

    struct PageContent {
        let button: UIButton
        let viewController: PageComponentProtocol
    }
}
