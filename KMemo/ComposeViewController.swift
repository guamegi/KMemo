//
//  ComposeViewController.swift
//  KMemo
//
//  Created by 나미콘 on 2019/12/01.
//  Copyright © 2019 나미콘. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var memoTableView: UITextView!
    
    
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTableView.text, memo.count > 0 else {
            // alert
            alert(message: "메모를 입력하세요")
            return
        }
        
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
}
