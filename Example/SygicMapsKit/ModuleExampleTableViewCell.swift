import UIKit


class ModuleExampleTableViewCell: UITableViewCell {

    @IBOutlet weak var mainCellView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageExample: UIImageView!
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle = "" {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    var imageName = "" {
        didSet {
            imageExample.image = UIImage(named: imageName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        mainCellView.layer.cornerRadius = 6
        mainCellView.layer.masksToBounds = true
        
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        mainCellView.backgroundColor = selected ? .lightGray : .white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        mainCellView.backgroundColor = highlighted ? .lightGray : .white
    }

}
