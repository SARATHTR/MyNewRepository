//
//  ViewController.swift
//  Test Project
//
//  Created by Acemero on 30/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageViewNavigationbar: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var collectionViewContentList: UICollectionView!
    
    var storedOffsets = [Int: CGFloat]()
    var contentList: ContentListModel?
    var contentArray = [Content]()
    
    var pageNumber = 1
    var paginationLimit = 0
    var isLastPageFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        collectionViewContentList.dataSource = self
        collectionViewContentList.delegate = self
        
        imageViewNavigationbar.addBottomShadow()
        
        let baseViewHeight = 35.0//baseView.frame.height
        let baseViewWidth = self.view.frame.width//baseView.frame.width
        
        let shadowSize: CGFloat = 15
        let contactRect = CGRect(x: -shadowSize, y: baseViewHeight - (shadowSize * 0.2), width: baseViewWidth + shadowSize * 2, height: shadowSize)
        baseView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        baseView.layer.shadowRadius = 5
        baseView.layer.shadowOpacity = 0.6
        
        apiCall(pageNumber: pageNumber)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func apiCall(pageNumber: Int) {
        if let jsonRsponse = loadJson(fileName: "CONTENTLISTINGPAGE-PAGE\(pageNumber)") {
            contentList = jsonRsponse
            guard let datas = contentList?.page.contentItems.content else { return }
            for data in datas {
                contentArray.append(data)
            }
            paginationLimit = Int(contentList?.page.pageSize ?? "0") ?? 0
            if self.contentArray.count < paginationLimit {
              self.isLastPageFetched = true
            }
            if self.contentArray.count == 0 {
              self.isLastPageFetched = true
            }
            
            DispatchQueue.main.async {
                self.collectionViewContentList.reloadData()
            }
        }
    }
    
    func loadJson(fileName: String) -> ContentListModel? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let contentData = try? decoder.decode(ContentListModel.self, from: data)
        else {
            return nil
        }
        return contentData
    }
    
    @IBAction func barButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 100:
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.textFieldSearch.isHidden = true
                self.labelTitle.isHidden = false
            }, completion: {(_ finished: Bool) -> Void in
                self.textFieldSearch.resignFirstResponder()
            })
        default:
            
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.textFieldSearch.isHidden = false
                self.labelTitle.isHidden = true
            }, completion: {(_ finished: Bool) -> Void in
                self.textFieldSearch.becomeFirstResponder()
            })
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListDataCollectionViewCell", for: indexPath) as! ListDataCollectionViewCell
        (cell.viewWithTag(100) as! UIImageView).image = UIImage(named: contentArray[indexPath.row].posterImage)
        (cell.viewWithTag(110) as! UILabel).text = contentArray[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if contentArray.count > 0 {
            print("<<<<<<<", contentArray.count - 1 == indexPath.row)
            print(contentArray.count % paginationLimit)
            print(isLastPageFetched)
            if contentArray.count - 1 == indexPath.row && contentArray.count % paginationLimit == 0 && isLastPageFetched == false {
                self.pageNumber += 1
                apiCall(pageNumber: self.pageNumber)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width - 36) / 3), height: 233)//collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}










