import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: view.bounds)
        label.text = "You shouldn't be here :)"
        label.textColor = .white
        view.addSubview(label)
    }

}
