//
//  ChattingListViewController.swift
//  DiffableDataSourceStudy
//
//  Created by 박성민 on 7/18/24.
//

import UIKit
import SnapKit

struct ChattingList: Hashable,Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let chatting: String
    
}
final class ChattingListViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ChattingList>
    
    private let textFiled = {
       let view = UISearchTextField()
        view.placeholder = "친구 이름을 검색해보세요"
        return view
    }()
    lazy var chattingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: DataSource!
    private let chatList = [
        ChattingList(image: "person.crop.circle", name: "성민", chatting: "안녕하세유"),
        ChattingList(image: "person.crop.circle", name: "수민", chatting: "맨날 놀재"),
        ChattingList(image: "person.crop.circle", name: "뽀로로", chatting: "노는게 제일 좋아유!"),
        ChattingList(image: "person.crop.circle", name: "냠냠이", chatting: "냠냠쩝쩝 후루루~"),
        ChattingList(image: "person.crop.circle", name: "개발잘하는 사람", chatting: "개발잘해서 부러워유...."),
        ChattingList(image: "person.crop.circle", name: "신입 개발자", chatting: "부럽다잉~~~~~~"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "TRAVEL TALK"
        configureDateSource()
        updateSnapshot()
    }
    override func setUpHierarchy() {
        view.addSubview(chattingCollectionView)
        view.addSubview(textFiled)
    }
    override func setUpLayout() {
        textFiled.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        chattingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textFiled.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    
    
}
// MARK: - collectionView 부분
extension ChattingListViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ChattingList>
    typealias Registeration = UICollectionView.CellRegistration<UICollectionViewListCell, ChattingList>
    private func createLayout() -> UICollectionViewLayout {
        var confige = UICollectionLayoutListConfiguration(appearance: .grouped)
        confige.backgroundColor = .white
        confige.showsSeparators = false
        confige.headerMode = .none
        
        let layout = UICollectionViewCompositionalLayout.list(using: confige)
        
        return layout
    }
    //cell의 대한 정의
    private func configureDateSource() {
        var register: Registeration!
        register = Registeration { cell, _, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.name
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            content.secondaryText = itemIdentifier.chatting
            content.image = UIImage(systemName: itemIdentifier.image)
            
            cell.contentConfiguration = content
        }
        dataSource = DataSource(collectionView: chattingCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: register, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    private func updateSnapshot() {
        var snap = Snapshot()
        snap.appendSections([0])
        snap.appendItems(chatList)
        
        dataSource.apply(snap)
    }
    
    
    
}
