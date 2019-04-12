//// SYMKSearchView.swift
//
// Copyright (c) 2019 - Sygic a.s.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the &quot;Software&quot;), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


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
    
    public func setupSearchBarView(_ searchView: UIView) {
        searchBarView = searchView
        searchView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchView)
        searchView.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        searchView.trailingAnchor.constraint(equalTo: safeTrailingAnchor).isActive = true
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
        backgroundColor = .background
    }
    
}
