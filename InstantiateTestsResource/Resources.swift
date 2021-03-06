//
//  Resources.swift
//  Instantiate
//
//  Created by tarunon on 2017/01/29.
//  Copyright © 2017 tarunon. All rights reserved.
//

import UIKit
import Instantiate
import InstantiateStandard

final class View: UIView, NibInstantiatable {
    typealias Parameter = UIColor
    var parameter: Parameter!
    
    func bind(to parameter: UIColor) {
        self.backgroundColor = parameter
    }
}

final class ViewController: UIViewController, StoryboardInstantiatable {
    typealias Parameter = String
    
    func bind(to parameter: String) {
        self.label.text = parameter
    }
        
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

@IBDesignable final class ViewWrapper: UIView, NibInstantiatableWrapper {
    typealias Wrapped = View
    @IBInspectable var color: UIColor = .white {
        didSet {
            viewIfLoaded?.bind(to: color)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadView(with: color)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        loadView(with: color)
    }
}

final class ViewController2: UIViewController, StoryboardInstantiatable {
    typealias Parameter = Void
    @IBOutlet weak var viewWrapper: ViewWrapper!
    
    static var storyboard: UIStoryboard = ViewController.storyboard
    static var instantiateSource: InstantiateSource { return .identifier(identifier(of: ViewController2.self)) }
}

final class TableViewCell: UITableViewCell, Reusable, NibType, Bindable {
    typealias Parameter = Int
    @IBOutlet weak var label: UILabel!
    
    func bind(to parameter: Int) {
        label.text = "\(parameter)"
    }
}

final class ViewController3: UIViewController, StoryboardInstantiatable {
    typealias Parameter = [Int]
    var dataSource = [Int]()
    
    static var storyboard: UIStoryboard = ViewController.storyboard
    static var instantiateSource: InstantiateSource { return .identifier(identifier(of: ViewController3.self)) }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerNib(type: TableViewCell.self)
        }
    }
    
    func bind(to parameter: [Int]) {
        dataSource = parameter
        tableView.reloadData()
    }
}

extension ViewController3: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeReusableCell(type: TableViewCell.self, for: indexPath, with: dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

final class CollectionViewCell: UICollectionViewCell, Reusable, NibType, Bindable {
    typealias Parameter = String
    @IBOutlet weak var label: UILabel!
    
    func bind(to parameter: String) {
        label.text = parameter
    }
}

final class CollectionReusableView: UICollectionReusableView, Reusable, NibType, Bindable {
    typealias Parameter = String
    @IBOutlet weak var label: UILabel!
    
    func bind(to parameter: String) {
        label.text = parameter
    }
}

final class ViewController4: UIViewController, StoryboardInstantiatable {
    typealias Parameter = [(header: String, items: [String])]
    var dataSource = [(header: String, items: [String])]()
    
    static var storyboard: UIStoryboard = ViewController.storyboard
    static var instantiateSource: InstantiateSource { return .identifier(identifier(of: ViewController4.self)) }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerNib(type: CollectionViewCell.self)
            collectionView.registerNib(type: CollectionReusableView.self, forSupplementaryViewOf: UICollectionElementKindSectionHeader)
        }
    }
    
    func bind(to parameter: Array<(header: String, items: [String])>) {
        dataSource = parameter
        collectionView.reloadData()
    }
}

extension ViewController4: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeReusableCell(type: CollectionViewCell.self, for: indexPath, with: dataSource[indexPath.section].items[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(type: CollectionReusableView.self, of: kind, for: indexPath, with: dataSource[indexPath.section].header)
    }
}
