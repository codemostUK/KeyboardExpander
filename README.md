# KeyboardExpander

A lightweight utility that automatically adjusts layout constraints when the keyboard appears or disappears. `KeyboardExpander` simplifies keyboard-driven UI changes by observing keyboard notifications and expanding or collapsing views in response—no manual offset math required.

![License](https://img.shields.io/github/license/codemostUK/KeyboardExpander)

---

## 🚀 Features

- Automatically listens for keyboard show/hide/frame change events
- Adjusts layout constraint constants in response to keyboard height
- Combine-based reactive observation
- Fully reusable — just drop into your view controller

---

## 📦 Installation

### CocoaPods

```ruby
pod 'KeyboardExpander', :git => 'https://github.com/codemostUK/KeyboardExpander.git'
```

### Swift Package Manager (coming soon)

---

## 📁 Folder Structure

```
Sources/
 └── KeyboardExpander.swift
```

---

## 🧪 Usage

```swift
@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
private var keyboardExpander: KeyboardExpander?

override func viewDidLoad() {
    super.viewDidLoad()

    keyboardExpander = KeyboardExpander(
        constraint: bottomConstraint,
        layoutView: view
    )
}
```

You can also customize with a constant offset:

```swift
keyboardExpander = KeyboardExpander(
    constraint: bottomConstraint,
    layoutView: view,
    offset: 16
)
```

To stop observing (e.g., on deinit):

```swift
keyboardExpander?.invalidate()
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

---

## 🧠 About

Part of the [CodeMost](https://github.com/codemostUK) open-source initiative. Created and maintained by [@codemostUK](https://github.com/codemostUK).
