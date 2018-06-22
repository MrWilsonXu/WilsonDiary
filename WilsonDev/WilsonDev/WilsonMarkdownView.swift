//
//  WilsonMarkdownView.swift
//  WilsonDev
//
//  Created by Wilson on 6/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import WebKit

class WilsonMarkdownView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /*loadMarkdownView(view: self)*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    func loadMarkdownView(view : UIView) ->() {
        let mdView = MarkdownView()
        view.addSubview(mdView);
        mdView.frame = view.frame;
        
        let path = Bundle.main.path(forResource: "sample", ofType: "md")!
        let url = URL(fileURLWithPath: path)
        let markdown = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        mdView.load(markdown: markdown, enableImage: true)
        
        mdView.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            print("%@",url)
            return true
        }
        
        mdView.onRendered = { height in
            print(height)
            self.setNeedsLayout()
        }
    
    }*/

}
