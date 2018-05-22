//
//  OutcodeInputViewController.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 22.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

protocol  OutcodeInputViewControllerDelegate: class {
    func didDismissOutcodeInputView(outcode: String)
}

class OutcodeInputViewController: UIViewController {

    weak var delegate: OutcodeInputViewControllerDelegate?
    @IBOutlet var textFieldOutcode: UITextField?
    @IBOutlet var label: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissOoutcodeInputView(sender:)))
        self.navigationItem.leftBarButtonItem = dismissButton
    }

    @objc private func dismissOoutcodeInputView(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        delegate?.didDismissOutcodeInputView(outcode: (textFieldOutcode?.text!)!)
    }

    @IBAction func didTappedButtonDefault(sender: AnyObject) {
        self.textFieldOutcode?.text = "se19"
    }

}
