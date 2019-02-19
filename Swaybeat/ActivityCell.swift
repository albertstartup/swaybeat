import UIKit

class ActivityCell: UITableViewCell {
  
  @IBOutlet weak var nameOutlet: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setModel(model: [String: AnyObject]) {
    if let name = model["name"] as? String {
      nameOutlet.text = name
    }
  }

}