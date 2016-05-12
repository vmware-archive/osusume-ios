import Nimble

// MARK: - Custom Matchers
internal func containSubview(containedView: UIView) -> NonNilMatcherFunc<UIView> {
    return NonNilMatcherFunc { expression, failureMessage in
        guard let superView = try expression.evaluate() else {
            return false
        }

        guard superView != containedView else {
            return false
        }

        return viewContainsSubview(superView, containedView: containedView)
    }
}

// MARK: - Private Methods
private func viewContainsSubview(superView: UIView, containedView: UIView) -> Bool {
    for subView in superView.subviews {
        if subView == containedView {
            return true
        } else if subView.subviews.count > 0 {
            return viewContainsSubview(subView, containedView: containedView)
        }
    }

    return false
}
