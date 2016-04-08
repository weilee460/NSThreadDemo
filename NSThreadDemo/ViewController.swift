//
//  ViewController.swift
//  NSThreadDemo
//
//  Created by ying on 16/4/8.
//  Copyright © 2016年 ying. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //定义两个线程
    var thread1: NSThread?
    var thread2: NSThread?
    
    //定义两个线程条件，用于锁住线程
    let condition1 = NSCondition()
    let condition2 = NSCondition()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        thread1 = NSThread(target: self, selector: "method1:", object: nil)
        thread2 = NSThread(target: self, selector: "method2:", object: nil)
        thread1?.start()
    }
    
    func method1(sender: AnyObject)
    {
        for var i = 0; i < 10; i++
        {
            print("NSThread 1 running \(i)")
            sleep(1)
            
            if i == 2
            {
                thread2?.start()
                //本线程thread1锁定
                condition1.lock()
                condition1.wait()
                condition1.unlock()
            }
        }
        
        print("NSThread 1 over")
        
        //线程2激活
        condition2.signal()
    }
    
    func method2(sender: AnyObject)
    {
        for var i = 0; i < 10; i++
        {
            print("NSThread 2 running \(i)")
            sleep(1)
            
            if i == 2
            {
                //线程1激活
                condition1.signal()
                
                //线程2锁定
                condition2.lock()
                condition2.wait()
                condition2.unlock()
            }
        }
        
        print("NSThread 2 over")
    }




}

