//
//  LoadingView.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/17.
//

import UIKit

class LoadingView: UIView {
    // MARK: - Private Property
    private lazy var didUpdateConstraints: Bool = false

    typealias LoadingHandler = () -> Void
    private var onLoadHandler: LoadingHandler?

    // MARK: - Subviews Property
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        return activityView
    }()

    init() {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()

        self.setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func addSubviews() {
        addSubview(containerView)
        addSubview(activityView)
    }

    var activityIndicatorSize: UIActivityIndicatorView.Style = .medium {
        didSet {
            if activityIndicatorSize != oldValue {
                activityView.style = activityIndicatorSize
            }
        }
    }

    func setActivityColor(_ color: UIColor) {
        activityView.color = color
    }

    func startLoading() {
        activityView.startAnimating()
        containerView.isHidden = true
    }

    func endLoading(completion: LoadingHandler?) {
        activityView.stopAnimating()

        UIView.animate(withDuration: 0.25,
                       animations: { [weak self] in
                        self?.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.isHidden = true
                self?.removeFromSuperview()
                completion?()
        })
    }

    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true

            containerView.snp.makeConstraints { maker in
                maker.center.equalToSuperview()
                maker.width.height.equalToSuperview()
            }

            activityView.snp.makeConstraints { maker in
                maker.center.equalToSuperview()
                maker.width.height.equalToSuperview()
            }
        }

        super.updateConstraints()
    }
}

extension UIViewController {
    private struct AssociatedKeys {
        static var loadingView: String = "LoadingView"
    }

    private var loadingView: LoadingView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingView) as? LoadingView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func startLoading(_ backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.1), targetView: UIView? = nil) {
        removeLoadingView()

        let parentView: UIView = targetView ?? self.view

        loadingView = LoadingView()
        loadingView?.backgroundColor = backgroundColor
        loadingView?.activityIndicatorSize = .medium

        if let loadingView = loadingView {
            parentView.addSubview(loadingView)
            loadingView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
        }

        loadingView?.startLoading()
    }

    func endLoading(_ handler: LoadingView.LoadingHandler? = nil) {
        loadingView?.endLoading(completion: { [weak self] in
            self?.removeLoadingView()
            handler?()
        })
    }

    // MARK: - Private
    private func removeLoadingView() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
