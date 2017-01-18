//
//  PictureSelectorView.swift
//  ImageSelector
//
//  Created by wangjiayu on 2016/12/24.
//  Copyright © 2016年 wangjiayu. All rights reserved.
//

import UIKit


private let Screenwidth = UIScreen.main.bounds.width
private let Screenheight = UIScreen.main.bounds.height
private let pictureCellReuseIdentifier = "pictureCellReuseIdentifier"


class PictureSelectorView: UIView {
    
    var pictures = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    ///初始化 UI
    private func setupUI() {
        //添加子控件
         addSubview(collectionView)
        //布局子控件
        
    }
    
    //MARK:- 懒加载
    fileprivate lazy var collectionView:UICollectionView = {
       let clv = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: Screenwidth, height: Screenheight), collectionViewLayout: pictureCellLayout())
        clv.backgroundColor = UIColor.lightGray
        clv.dataSource = self
        clv.register(pictureCell.self, forCellWithReuseIdentifier: pictureCellReuseIdentifier)
        
        return clv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- <UICollectionViewDataSource>
extension PictureSelectorView:UICollectionViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureCellReuseIdentifier, for: indexPath) as! pictureCell
        cell.addButton.addTarget(self, action: #selector(addButtonClick), for: UIControlEvents.touchUpInside)
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(removeButtonClick), for: UIControlEvents.touchUpInside)
        
        cell.image = (pictures.count == indexPath.item) ? nil : pictures[indexPath.item]
        return cell
    }
    
    ///添加按钮响应事件
    func addButtonClick() {
        let pickerVC = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            return
        }
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        if (self.superview?.next?.isKind(of: UIViewController.self))! {
            print("hahh")
            let controllerss = superview?.next as! UIViewController
            controllerss.present(pickerVC, animated: true, completion: nil)
        }
    }
    ///删除按钮响应事件
    func removeButtonClick(btn:UIButton) {
        pictures.remove(at: btn.tag)
        collectionView.reloadData()
    }
    
    //MARK:- UIImagePickerController的代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage).imageWithScale(imageWidth: 300)
        pictures.append(image)
        collectionView.reloadData()

        picker.dismiss(animated: true, completion: nil)
        
    }
}

//MARK:- 自定义 cell
fileprivate class pictureCell:UICollectionViewCell {
    
    fileprivate var image:UIImage? {
        didSet {
            if image != nil {
                addButton.setBackgroundImage(image, for: UIControlState.normal)
                removeButton.isHidden = false
            } else {
                removeButton.isHidden = true
                addButton.setBackgroundImage(UIImage.init(named: "compose_pic_add"), for: UIControlState.normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    ///初始化 UI
    private func setupUI() {
        //添加子控件
        addSubview(addButton)
        addSubview(removeButton)
        //布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        //添加按钮
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["addButton":addButton])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["addButton":addButton])
        //删除按钮
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:[removeButton]-2-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["removeButton":removeButton])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[removeButton]", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["removeButton":removeButton])
        //添加约束
        addConstraints(cons)
    }
    
    
    //MARK:- 懒加载
    ///添加按钮
    fileprivate lazy var addButton:UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage.init(named: "compose_pic_add"), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(named: "compose_pic_add_highlighted"), for: UIControlState.highlighted)
        return btn
    }()
    ///删除按钮
    fileprivate lazy var removeButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "compose_photo_close"), for: UIControlState.normal)
        btn.isHidden = true
        return btn
    }()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK:- 自定义布局
fileprivate class pictureCellLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = CGSize.init(width: 80, height: 80)
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}
