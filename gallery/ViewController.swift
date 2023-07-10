import UIKit
import SnapKit

class MainViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout: UICollectionViewCompositionalLayout = {
            let fraction: CGFloat = 1 / 4
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return UICollectionViewCompositionalLayout(section: section)
        }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
}()

override func viewDidLoad() {
    super.viewDidLoad()
    setupScene()
    setupDelegates()
    setupNavigationBar()
    makeConstraints()
}

private func setupScene() {
    title = "Gallery"
    view.addSubview(collectionView)
}

private func setupDelegates() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(GalleryItemCell.self, forCellWithReuseIdentifier: GalleryItemCell.cellId)
}

private func setupNavigationBar() {
    let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings))
    navigationItem.rightBarButtonItem = settingsButton
}

private func makeConstraints() {
    collectionView.snp.makeConstraints {
        $0.edges.equalToSuperview()
    }
}

@objc private func openSettings() {
    let settingsViewController = SettingsViewController()
    settingsViewController.delegate = self
    navigationController?.pushViewController(settingsViewController, animated: true)
}
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryItemCell.cellId, for: indexPath) as! GalleryItemCell
    cell.configure()
    return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! GalleryItemCell
    let cellBackgroundColor = cell.contentView.backgroundColor
    let detailsViewController = DetailsViewController()
    detailsViewController.view.backgroundColor = cellBackgroundColor
    navigationController?.pushViewController(detailsViewController, animated: true)
}
}

extension MainViewController: SettingsViewControllerDelegate {
    func didUpdateSettings(numberOfColumns: Int, interItemSpacing: CGFloat) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = interItemSpacing
        layout.minimumInteritemSpacing = interItemSpacing

    let screenWidth = UIScreen.main.bounds.width
    let itemWidth = (screenWidth - CGFloat(numberOfColumns + 1) * interItemSpacing) / CGFloat(numberOfColumns)
    layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

    collectionView.collectionViewLayout = layout
    collectionView.reloadData()
}
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?

let numberOfColumnsSlider: UISlider = {
    let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    slider.minimumValue = 1
    slider.maximumValue = 4
    return slider
}()
    
let interItemSpacingSlider: UISlider = {
    let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    slider.minimumValue = 0
    slider.maximumValue = 20
    return slider
}()

let saveButton: UIButton = {
    let button = UIButton()
    button.setTitle("Save", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
    return button
}()
override func viewDidLoad() {
    super.viewDidLoad()
    setupScene()
    makeConstraints()
}

private func setupScene() {
    title = "Settings"
    view.backgroundColor = .white
    view.addSubview(numberOfColumnsSlider)
    view.addSubview(interItemSpacingSlider)
    view.addSubview(saveButton)
}

private func makeConstraints() {
    numberOfColumnsSlider.center = self.view.center
    interItemSpacingSlider.center = self.view.center

    saveButton.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(interItemSpacingSlider.snp.bottom).offset(80)
    }
}

@objc private func saveSettings() {
    let numberOfColumns = Int(numberOfColumnsSlider.value)
    let interItemSpacing = interItemSpacingSlider.value
    delegate?.didUpdateSettings(numberOfColumns: numberOfColumns, interItemSpacing: CGFloat(interItemSpacing))
    navigationController?.popViewController(animated: true)
}
}

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateSettings(numberOfColumns: Int, interItemSpacing: CGFloat)
}

