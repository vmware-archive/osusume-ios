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

internal func hasConstraintsToSuperviewOrSelf() -> NonNilMatcherFunc<UIView> {
    return NonNilMatcherFunc { expression, failureMessage in
        guard let viewToCheck = try expression.evaluate() else {
            return false
        }

        guard let superView = viewToCheck.superview else {
            return viewToCheck.constraints.count > 0
        }

        for constraint in superView.constraints {
            if (constraint.firstItem === viewToCheck ||
                constraint.secondItem === viewToCheck) {
                return true
            }
        }

        return viewToCheck.constraints.count > 0
    }
}

internal func hasConstraintsToSuperview() -> NonNilMatcherFunc<UIView> {
    return NonNilMatcherFunc { expression, failureMessage in
        guard let viewToCheck = try expression.evaluate() else {
            return false
        }

        if let superView = viewToCheck.superview {
            for constraint in superView.constraints {
                if (constraint.firstItem === viewToCheck ||
                    constraint.secondItem === viewToCheck) {
                    return true
                }
            }
        }

        return false
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
