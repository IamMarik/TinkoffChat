//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Marik on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        Log.d("View created: \(#function)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.d("View loaded into memory: \(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.d("ViewController moved from Disappeared to Appearing: \(#function)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Log.d("ViewController moved from Appearing to Appeared: \(#function)")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Log.d(#function)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Log.d(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Log.d("ViewController moved from Appeared to Disappearing: \(#function)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         Log.d("ViewController moved from Disappearing to Disappeared: \(#function)")
    }

}

