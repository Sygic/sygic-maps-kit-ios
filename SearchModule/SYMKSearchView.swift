

class SYMKSearchView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        let searchBar = UISearchBar(frame: .zero)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: safeTrailingAnchor).isActive = true
    }
    
}
