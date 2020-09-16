//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Dzhanybaev Marat on 12.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        Log.d("View created: \(#function)", tag: "ViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.d("View loaded into memory: \(#function)", tag: "ViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.d("ViewController moved from Disappeared to Appearing: \(#function)", tag: "ViewController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Log.d("ViewController moved from Appearing to Appeared: \(#function)", tag: "ViewController")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Log.d(#function, tag: "ViewController")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Log.d(#function, tag: "ViewController")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Log.d("ViewController moved from Appeared to Disappearing: \(#function)", tag: "ViewController")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Log.d("ViewController moved from Disappearing to Disappeared: \(#function)", tag: "ViewController")
    }

}
