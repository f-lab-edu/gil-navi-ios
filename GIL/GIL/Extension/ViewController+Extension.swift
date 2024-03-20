//
//  ViewController+Extension.swift
//  GIL
//
//  Created by 송우진 on 3/19/24.
//

import UIKit

extension UIViewController {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
