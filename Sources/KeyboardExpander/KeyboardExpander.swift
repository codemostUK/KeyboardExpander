//
//  KeyboardExpander.swift
//  KeyboardExpander
//
//  Created by Tolga Seremet on 14.03.2023.
//  Copyright © 2023 Codemost.
//

import UIKit
import Combine

/// An open controller that manages a view's layout, expanding it when the keyboard appears and shrinking it when the keyboard hides.
/// This controller is useful for ensuring that content is not obscured by the keyboard during user input.
final public class KeyboardExpander: NSObject {

    /// The scroll view that will be adjusted when the keyboard appears or disappears.
    @IBOutlet public weak var scrollView: UIScrollView! {
        didSet {
            setupBindings()
        }
    }

    /// The constraint that will be modified to account for the keyboard's height.
    @IBOutlet public weak var constraint: NSLayoutConstraint! {
        didSet {
            setupBindings()
        }
    }

    /// The parent view that contains the scroll view and will be laid out accordingly.
    @IBOutlet public weak var parentView: UIView! {
        didSet {
            setupBindings()
        }
    }

    /// Additional padding for the scroll view when the keyboard is shown.
    @IBInspectable public var extraPaddingForScrollView: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()

    public override init() {
        super.init()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

// MARK: - Notifications
public extension KeyboardExpander {

    /// Sets up bindings to observe keyboard show and hide notifications.
    private func setupBindings()  {

        guard cancellables.count == 0 else { return }

        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] notification in

            switch notification.name {
                case UIResponder.keyboardWillShowNotification:
                    if let sendable = self?.sendableCopy(notification: notification) {
                    KeyboardExpander.keyboardWillShowHandler(sendable)
                    }

                case UIResponder.keyboardWillHideNotification:
                    if let sendable = self?.sendableCopy(notification: notification) {
                    KeyboardExpander.keyboardWillHideHandler(sendable)
                    }

                default:
                    break
            }
        })
        .store(in: &cancellables)
    }

    /// Handles the keyboard appearing event, updating the scroll view insets and constraint to accommodate the keyboard.
    private static func keyboardWillShowHandler(_ sendable: KeyboardExpander.SendableCopy) {

        Task { @MainActor in

            guard let keyboardFrame = sendable.keyboardFrame else { return }

            let safeAreaInsetsBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

            let keyboardHeight = keyboardFrame.size.height - safeAreaInsetsBottom

            if let scrollView = sendable.scrollView {
                let keyboardHeightForScrollView = (sendable.extraPaddingForScrollView ?? 0) + keyboardHeight
                let insets = UIEdgeInsets(top: scrollView.contentInset.top,
                                          left: scrollView.contentInset.left,
                                          bottom: keyboardHeightForScrollView,
                                          right: scrollView.contentInset.right)
                scrollView.contentInset = insets
                scrollView.scrollIndicatorInsets = insets
            }

            guard
                let constraint = sendable.constraint,
                let parentView = sendable.parentView
            else { return }

            constraint.constant = keyboardHeight

            if let keyboardAnimationDuration = sendable.keyboardAnimationDuration {
                UIView.animate(withDuration: keyboardAnimationDuration) {
                    parentView.layoutIfNeeded()
                }
            }
        }
    }

    /// Handles the keyboard hiding event, resetting the scroll view insets and constraint to their original states.
    private static func keyboardWillHideHandler(_ sendable: KeyboardExpander.SendableCopy) {

        Task { @MainActor in

            if let scrollView = sendable.scrollView {
                let insets = UIEdgeInsets(top: scrollView.contentInset.top,
                                          left: scrollView.contentInset.left,
                                          bottom: 0,
                                          right: scrollView.contentInset.right)
                scrollView.contentInset = insets
                scrollView.scrollIndicatorInsets = insets
            }

            guard
                let constraint = sendable.constraint,
                let parentView = sendable.parentView
            else { return }

            constraint.constant = sendable.extraPaddingForScrollView ?? 0

            if let keyboardAnimationDuration = sendable.keyboardAnimationDuration {
                UIView.animate(withDuration: keyboardAnimationDuration) {
                    parentView.layoutIfNeeded()
                }
            }
        }
    }
}

extension KeyboardExpander {

    /// A structure that holds information needed to update the UI in a thread-safe manner.
    /// It is marked with `@MainActor` to ensure UI updates occur on the main thread and `Sendable` for concurrency safety.
    @MainActor struct SendableCopy: Sendable {
        let keyboardFrame: CGRect?
        let keyboardAnimationDuration: Double?
        let scrollView: UIScrollView?
        let extraPaddingForScrollView: CGFloat?
        let constraint: NSLayoutConstraint?
        let parentView: UIView?
    }

    /// Constructs a `SendableCopy` from the notification's userInfo, extracting relevant keyboard information.
    func sendableCopy(notification: Notification) -> SendableCopy {

        var keyboardFrame: CGRect?
        var keyboardAnimationDuration: Double?

        if let keyboardFrameUserInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardFrame = keyboardFrameUserInfo
        }

        if let keyboardAnimationDurationUserInfo = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            keyboardAnimationDuration = keyboardAnimationDurationUserInfo
        }

        return SendableCopy(keyboardFrame: keyboardFrame,
                            keyboardAnimationDuration: keyboardAnimationDuration,
                            scrollView: scrollView,
                            extraPaddingForScrollView: extraPaddingForScrollView,
                            constraint: constraint,
                            parentView: parentView)
    }
}
