class ProfileViewController: UIViewController {
  
  init(withUserId id: String, title: String?) {
    super.init(nibName: "ProfileViewController", bundle: nil)
    if let name = title {
      navigationItem.title = name
    }
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
