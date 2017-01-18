//
//  QRCodeViewController.swift
//  WeiBo
//
//  Created by fangjs on 2016/11/10.
//  Copyright © 2016年 fangjs. All rights reserved.
// sudo gem install -n /usr/local/bin  cocoapods

//private: 私有属性和方法，仅在当前类中可以访问，不包括分类；
//fileprivate: 文件内私有属性和方法，仅在当前文件中可以访问，包括同一个文件中不同的类。


import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    //MARK:- storyboard 中所关联的属性
    //自定义的 TabBar
    @IBOutlet weak var customTabBar: UITabBar!
    //冲击波的顶部位置
    @IBOutlet weak var scanlineCons: NSLayoutConstraint!
    //冲击波
    @IBOutlet weak var scanlineView: UIImageView!
    //边框的高度约束
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    //关闭按钮的响应事件
    @IBAction func closeBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    //显示我的名片
    @IBAction func showMyCard(_ sender: AnyObject) {
        let vc = QRcodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //定义动画时长
    let duration:TimeInterval = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "扫描二维码"
        //设置 Tabbar 的代理
        customTabBar.delegate = self  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //开始动画
        startAnimation()
        
        //开始扫面
        startScan()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
  
    //开始动画
    //fileprivate: 文件内私有属性和方法，仅在当前文件中可以访问，包括同一个文件中不同的类。
   fileprivate func startAnimation() {
        scanlineView.isHidden = false
        //现将冲击波的起始位置上移containerHeight.constant的高度
        scanlineCons.constant = 15.0 - containerHeight.constant
        //强制更新
        view.layoutIfNeeded()
        
        //设置动画
        UIView.animate(withDuration: duration) {
            self.scanlineCons.constant = 12.0
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }
    
    //开始扫面
    //private: 私有属性和方法，仅在当前类中可以访问，不包括分类；
    private func startScan() {
        //1. 判断能否添加输入设备
        if !session.canAddInput(input){ return }
        //2. 判断能否添加输出设备
        if !session.canAddOutput(output){ return }
        //3. 添加输入设备
        session.addInput(input)
        //4. 添加输出设备
        session.addOutput(output)
        //5. 设置代理监听输出对象输出的数据
        //注意: 设置输出对象能够解析的类型必须在数处对象添加到会话以后设置,否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //6. 设置预览层
        previewLayer.addSublayer(drawLayer)
        view.layer.insertSublayer(previewLayer, at: 0)
        //7. 开始扫面
        session.startRunning()
    }
    
    //a. 创建会话(桥梁)
    lazy var session:AVCaptureSession = AVCaptureSession()
    
    //b. 获取输入设备(摄像头)
    private lazy var input:AVCaptureInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            //模拟没有摄像头
            return try AVCaptureDeviceInput(device: device)
        }catch{
            print(error)
            return nil
        }
    }()
    
    //c. 获取输出设备
    private lazy var output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //d.创建预览图层
    lazy var previewLayer:AVCaptureVideoPreviewLayer = {
       //1. 创建预览图层
        let myLayer = AVCaptureVideoPreviewLayer(session: self.session)
        //2. 设置 frame
        // myLayer?.frame = CGRect(x: 37.5, y: 183.5, width: 300, height: 300)
        myLayer?.frame = self.view.frame
        //3. 设置填充模式,否则4s 会有问题
        myLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        return myLayer!
    }()
    
    //e. 创建边框图层
    lazy var drawLayer:CALayer = {
       let myLayer = CALayer()
        myLayer.frame = self.view.frame
        return myLayer
    }()
}

//MARK:- UITabBarDelegate
extension QRCodeViewController:UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1) {//二维码
            containerHeight.constant = 300
        } else { //条形码
            //设置容器视图的高度为原来高度的一半
            containerHeight.constant = containerHeight.constant * 0.5
            //移除所有动画(先移除动画再重新开始动画,这样就可以保证冲击波的顶部始终紧挨着边框的顶部)
            view.layer.removeAllAnimations()
        }
        //开始动画
        startAnimation()
    }
}

//MARK:- AVCaptureMetadataOutputObjectsDelegate!
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        //先清除上一次画的边框
        clearDrawLayer()

        //绘制路径
        for object in metadataObjects {
            if object is AVMetadataMachineReadableCodeObject {
                //转换原数据对象坐标
                let codeObject = previewLayer.transformedMetadataObject(for: object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                drawCorners(codeObject: codeObject)
            }
        }
        
        if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            //隐藏冲击波
            scanlineView.isHidden = true
            //显示扫描结果
            confirm(title: "扫描结果", message: resultObj.stringValue, controller: self,handler: { (_) in
                //继续扫描
                self.startAnimation()
            })
        }
    }
    
    ///画边框
    private func drawCorners(codeObject:AVMetadataMachineReadableCodeObject) {
        //0.判断数组是否为空
        if codeObject.corners.isEmpty { return }
        //1. 创建图层
        let createLayer = CAShapeLayer()
        createLayer.lineWidth = 4
        createLayer.strokeColor = UIColor.green.cgColor
        createLayer.fillColor = UIColor.clear.cgColor
        //2. 绘制图形
        createLayer.path = cornerPath(corners: codeObject.corners as NSArray)
        //3. 添加图层
        drawLayer.addSublayer(createLayer)
    }
    
    ///清除边框
    private func cornerPath(corners:NSArray) -> CGPath{
        //1.创建路径
        var index = 0
        let path = UIBezierPath()
        var point = CGPoint.zero
        //2.取出第0个点
        point =  CGPoint(dictionaryRepresentation: corners[index] as! CFDictionary)!
        //3.移动到第一个点
        path.move(to: point)
        //4.设置其他的点
        while index < corners.count {
            point = CGPoint(dictionaryRepresentation: corners[index] as! CFDictionary)!
            path.addLine(to: point)
            index += 1
        }
        //5.关闭路径
        path.close()

        return path.cgPath
    }
    ///清除边框线
    private func clearDrawLayer() {
        if drawLayer.sublayers?.count == 0 || drawLayer.sublayers == nil { return }
        for layer in drawLayer.sublayers! {
            layer.removeFromSuperlayer()
        }
    }
    
    private func confirm(title:String?,message:String?,controller:UIViewController,handler: ( (UIAlertAction) -> Swift.Void)? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let entureAction = UIAlertAction(title: "确定", style: .destructive, handler: handler)
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)
    }
    
}
