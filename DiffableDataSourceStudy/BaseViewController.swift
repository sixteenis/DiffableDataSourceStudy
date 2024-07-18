//
//  BaseViewController.swift
//  DiffableDataSourceStudy
//
//  Created by 박성민 on 7/18/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setUpHierarchy()
        setUpView()
        setUpLayout()
        bindData()
    }
    
    func setUpHierarchy() {}
    func setUpLayout() {}
    func setUpView() {}
    func bindData() {}
    
}
