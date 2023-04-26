import UIKit

class FilterButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  convenience init(withTitle title: String) {
    self.init(frame: .zero)
    configure(withTitle: title)
  }


  private func configure(withTitle title: String) {
    setTitle(title, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    layer.borderColor = UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1).cgColor
    layer.borderWidth = 1.0
    setTitleColor(UIColor(red: 109/255.0, green: 93/255.0, blue: 231/255.0, alpha: 1), for: .normal)
    backgroundColor = .clear
    layer.cornerRadius = 8
  }

  
  func setImageWithTitle(image: UIImage?) {
    setImage(image, for: .normal)

    tintColor = .red

    contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    if imageView != nil {
      titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -1)
    }
  }
}
