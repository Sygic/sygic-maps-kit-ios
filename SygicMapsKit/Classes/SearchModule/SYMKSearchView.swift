

class SYMKSearchView: UIView {
    
    public var searchBarView: UIView?
    public var searchResultsView: UIView?
    
    // MARK: - Public methods
    
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
    
    public func setupResultsView(_ resultsView: UIView) {
        searchResultsView = resultsView
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(resultsView)
        resultsView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        resultsView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        resultsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        if let searchBar = searchBarView {
            resultsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        } else {
            resultsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        backgroundColor = .white
        
        let searchBar = UISearchBar(frame: .zero)
        searchBarView = searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: safeTrailingAnchor).isActive = true
    }
    
}
