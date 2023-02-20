import UIKit

final class PostViewController: UIViewController {
    
    let model: PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let colors: [UIColor] = [
            .red, .green, .black, .orange, .blue, .gray, .systemPink
        ]
        
        view.backgroundColor = colors.randomElement()
    }
}
