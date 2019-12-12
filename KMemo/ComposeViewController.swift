//
//  ComposeViewController.swift
//  KMemo
//
//  Created by 나미콘 on 2019/12/01.
//  Copyright © 2019 나미콘. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    
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
        
        if let editTarget = editTarget {
            editTarget.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTableView.text = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTableView.text = ""
        }
        
        // 키보드 올라오면 키보드 높이만큼 하단 공백 생성
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTableView.contentInset
                inset.bottom = height
                strongSelf.memoTableView.contentInset = inset
                
                // scroll 에도 하단 여백
                inset = strongSelf.memoTableView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTableView.scrollIndicatorInsets = inset
            }
        })
        
        // 키보드 내려가면 하단 공백 제거
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.memoTableView.contentInset
            inset.bottom = 0
            strongSelf.memoTableView.contentInset = inset
            
            // scroll 에도 하단 여백
            inset = strongSelf.memoTableView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTableView.scrollIndicatorInsets = inset
            
        })
    }
    
    // 뷰가 생성되기 직전에 테이블뷰에 포커스가 선택되도록
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTableView.becomeFirstResponder()
    }
    
    // 뷰가 사라지기 전에 포커스 해제
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memoTableView.resignFirstResponder()
    }
    
}

extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
