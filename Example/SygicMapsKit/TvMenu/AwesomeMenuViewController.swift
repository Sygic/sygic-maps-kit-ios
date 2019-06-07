import UIKit
import SygicUIKit
import SygicMapsKit

class AwesomeMenuViewController: UIViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        
        if let naviBar = navigationController?.navigationBar {
            naviBar.setBackgroundImage(UIImage(), for: .default)
            naviBar.shadowImage = UIImage()
            naviBar.isTranslucent = true
            naviBar.tintColor = UIColor(red: 32.0/255.0, green: 93.0/255.0, blue: 1, alpha: 1)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "blueLogo"), style: .plain, target: nil, action: nil)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        tableView.coverWholeSuperview()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension AwesomeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let collectionCell = CollectionTableViewCell()
            collectionCell.setup()
            collectionCell.delegate = self
            return collectionCell
        } else if indexPath.section == 1 {
            let collectionCell = SmallerCollectionTableViewCell()
            collectionCell.setup()
            collectionCell.delegate = self
            return collectionCell
        } else if indexPath.section == 2 {
            let cell = ShowAllTableCell()
            cell.setup()
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        cell.imageView?.image = UIImage(named: "linkArrow")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Source code"
        case 1:
            cell.textLabel?.text = "Wiki page"
        case 2:
            cell.textLabel?.text = "Sygic.com"
        default:
            break;
        }
        cell.accessoryType = .disclosureIndicator
        cell.contentView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 140
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .green
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            navigationController?.pushViewController(BrowseExamplesTableViewController(), animated: true)
        }
        
        if indexPath.section == 3 {
            var url: String
            switch indexPath.row {
            case 0:
                url = "https://github.com/Sygic/sygic-maps-kit-ios"
            case 1:
                url = "https://github.com/Sygic/sygic-maps-kit-ios/wiki"
            default:
                url = "https://www.sygic.com"
            }
            guard let safariUrl = URL(string: url) else { return }
            UIApplication.shared.open(safariUrl)
        }
    }
}

extension AwesomeMenuViewController: CollectionTableViewCellDelegate {
    func collectionTableCell(_ cell: UITableViewCell, didSelectItem: Int) {
        let indexPath = tableView.indexPath(for: cell)
        if indexPath?.section == 0 {
            switch didSelectItem {
            case 0:
                navigationController?.pushViewController(SYMKBrowseMapViewController(), animated: true)
            case 1:
                navigationController?.pushViewController(CustomSkinExampleViewController(), animated: true)
            default:
                navigationController?.pushViewController(BrowseMapSelectionModesExampleViewController(), animated: true)
            }
        }
        if indexPath?.section == 1 {
            switch didSelectItem {
            case 0:
                navigationController?.pushViewController(SYMKSearchViewController(), animated: true)
            default:
                navigationController?.pushViewController(BrowseMapWithSearchResults(), animated: true)
            }
        }
    }
}

///////////

class ShowAllTableCell: UITableViewCell {
    let title = UILabel()
    func setup() {
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = SYUIFont.with(SYUIFont.semiBold, size: SYUIFontSize.headingOld)
        title.text = "VIEW ALL EXAMPLES →"
        title.textColor = UIColor(red: 32.0/255.0, green: 93.0/255.0, blue: 1, alpha: 1)
        contentView.addSubview(title)
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: 24).isActive = true
    }
}


////////////////////////

protocol CollectionTableViewCellDelegate {
    func collectionTableCell(_ cell: UITableViewCell, didSelectItem: Int)
}

class CollectionTableViewCell: UITableViewCell {
    var delegate: CollectionTableViewCellDelegate?
    let cellRI = "identifier"
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    func setup() {
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 264).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.coverWholeSuperview()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 160, height: 264)
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: cellRI)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellRI, for: indexPath) as! CollectionCell
        switch indexPath.item {
        case 0:
            cell.update(with: UIImage(named: "Artboard1"), text: "Basic map view")
        case 1:
            cell.update(with: UIImage(named: "Artboard2"), text: "Map styles")
        case 2:
            cell.update(with: UIImage(named: "Artboard3"), text: "Selection modes")
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionTableCell(self, didSelectItem: indexPath.item)
    }
}

class CollectionCell: UICollectionViewCell {
    let imageView = UIImageView()
    let imageHolder = UIView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .clear
        
        imageHolder.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageHolder)
        imageHolder.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        imageHolder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        imageHolder.setupDefaultShadow()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageHolder.addSubview(imageView)
        imageView.coverWholeSuperview()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .textTitle
        label.font = SYUIFont.with(SYUIFont.bold, size: SYUIFontSize.headingOld)
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        imageView.setupDefaultShadow()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
    }
    
    func update(with image: UIImage?, text: String) {
        imageView.image = image
        label.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = ""
    }
}


/////////////////////
class SmallerCollectionTableViewCell: UITableViewCell {
    var delegate: CollectionTableViewCellDelegate?
    let cellRI = "identifier"
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    func setup() {
        backgroundColor = .clear
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.coverWholeSuperview()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 216, height: 64)
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
            flowLayout.minimumLineSpacing = 24
            flowLayout.minimumInteritemSpacing = 24
        }
        collectionView.register(SmallerCollectionCell.self, forCellWithReuseIdentifier: cellRI)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SmallerCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellRI, for: indexPath) as! SmallerCollectionCell
        switch indexPath.item {
        case 0:
            cell.update(with: UIImage(named: "list"), text: "Default search with listings")
        case 1:
            cell.update(with: UIImage(named: "search"), text: "Search integration with map")
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionTableCell(self, didSelectItem: indexPath.item)
    }
}

class SmallerCollectionCell: CollectionCell {
    override func setup() {
        backgroundColor = .clear
        
        imageHolder.translatesAutoresizingMaskIntoConstraints = false
        imageHolder.backgroundColor = .textTitle
        contentView.addSubview(imageHolder)
        imageHolder.coverWholeSuperview()
        imageHolder.setupDefaultShadow()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = SYUIFont.with(SYUIFont.regular, size: 15)
        label.numberOfLines = 2
        contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.setupDefaultShadow()
        
        imageHolder.clipsToBounds = true
        imageHolder.layer.cornerRadius = 16
    }
}
