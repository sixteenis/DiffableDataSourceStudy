//
//  ViewController.swift
//  DiffableDataSourceStudy
//
//  Created by 박성민 on 7/18/24.
//

import UIKit
import SnapKit

struct settingModel: Hashable, Identifiable {
    let id = UUID().uuidString
    let image: String
    let MainTitle: String
    let subtTtle: String
}

enum settingSection: String, CaseIterable {
    case allset = "전체 설정"
    case privateSet = "개인 설정"
    case etc = "기타"
    
    var settingList: [settingModel] {
        switch self {
        case .allset:
            let list = [
                settingModel(image: "pencil.and.list.clipboard", MainTitle: "공지사항", subtTtle: "공지공지"),
                settingModel(image: "brain", MainTitle: "실험실", subtTtle: "실실"),
                settingModel(image: "macpro.gen1", MainTitle: "버전 정보", subtTtle: "1.0.1")
            ]
            return list
        case .privateSet:
            let list = [
                settingModel(image: "iphone.gen3", MainTitle: "개인/보안", subtTtle: "개보개보~"),
                settingModel(image: "bubble.left.and.text.bubble.right.fill", MainTitle: "알림", subtTtle: "알보치"),
                settingModel(image: "bubble.left.and.bubble.right.fill", MainTitle: "채팅", subtTtle: "챗바퀴"),
                settingModel(image: "person.circle", MainTitle: "멀티프로필", subtTtle: "프로포즈~ 느낌~")
            ]
            return list
        case .etc:
            let list = [
                settingModel(image: "waveform.and.person.filled", MainTitle: "고객센터/도움말", subtTtle: "도움말? 얼룩말?")
            ]
            return list
        }
    }
}
extension NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<settingSection, settingModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<settingSection, settingModel>
    typealias Registeration = UICollectionView.CellRegistration<UICollectionViewListCell, settingModel>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
}

final class SettingViewController: BaseViewController {
    lazy var settingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpView() {
        navigationItem.title = "설정"
        view.addSubview(settingCollectionView)
        settingCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        configureDataSource()
        updateSnapshot()
    }
    
}

// MARK: - collection 뷰 셋팅 부분
private extension SettingViewController {
     func createLayout() -> UICollectionViewLayout{ // 레이아웃 셋팅
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .white
        configuration.showsSeparators = false
        configuration.headerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
     func configureDataSource() {
        var registeration: Registeration!
        registeration = Registeration { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.image = UIImage(systemName: itemIdentifier.image)
            content.text = itemIdentifier.MainTitle
            content.secondaryText = itemIdentifier.subtTtle
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .lightGray
            
            cell.backgroundConfiguration = backgroundConfig
            cell.contentConfiguration = content
            
        }
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var content = supplementaryView.defaultContentConfiguration()
            content.text = settingSection.allCases[indexPath.section].rawValue
            content.textProperties.color = .black
            content.textProperties.font = .systemFont(ofSize: 18)
            supplementaryView.contentConfiguration = content
        }
        
        dataSource = DataSource(collectionView: settingCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registeration, for: indexPath, item: itemIdentifier) //item == 데이터 전달
            return cell
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            }
    }
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(settingSection.allCases) //세션
        settingSection.allCases.forEach {
            snapshot.appendItems($0.settingList, toSection: $0) // 실제 아이템
        }
        dataSource.apply(snapshot) //reloadData
        
    }
}
