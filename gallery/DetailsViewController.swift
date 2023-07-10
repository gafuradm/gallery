import UIKit

class DetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
}

private extension DetailsViewController {
    func setupScene() {
        title = "Gallery Item"
    }
}
