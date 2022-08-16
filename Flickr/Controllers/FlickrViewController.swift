//
//  ViewController.swift
//  Flickr
//
//  Created by Himanshu Lahoti on 12/06/22.
//

import UIKit
import SDWebImage

class FlickrViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var displayCollection: UICollectionView!
    @IBOutlet weak var displayView: UIView!
    var images = [Photo]()
    var photoManager = PhotoManager()
    var noOfColumns = 3.0
    var pagecount = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        photoManager.delegate = self
        searchBar.placeholder = "Search for Photos"
        searchBar.showsCancelButton = false
        displayView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        
    }
    
    func getData(){
        pagecount = pagecount + 50
        photoManager.fetchImage(imageText: searchBar.text!, pageCount: pagecount)
        displayView.isHidden = true
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}


extension FlickrViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = displayCollection.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! MyCollectionViewCell
        let image = images[indexPath.row].imageURL
        cell.dispalyedImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.dispalyedImage.sd_imageIndicator?.startAnimatingIndicator()
        cell.dispalyedImage.sd_setImage(with: URL(string: image))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (images.count - 20) {
            getData()
        }
    }
}
extension FlickrViewController: PhotoManagerDelegate{
    func fetchedImages(imageData: [Photo]) {
        images.append(contentsOf: imageData)
        DispatchQueue.main.async {
            self.displayCollection.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension FlickrViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData()
        displayCollection.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        images.removeAll()
        //displayCollection.isHidden = true
        displayView.isHidden = false
        displayCollection.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

extension FlickrViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = displayCollection.frame.width
        if (size > 500) {
            return CGSize(width: (displayCollection.bounds.width)/CGFloat(noOfColumns+3), height: (displayCollection.bounds.width)/CGFloat(noOfColumns+3))
        }
        return CGSize(width: (displayCollection.bounds.width)/CGFloat(noOfColumns), height: (displayCollection.bounds.width)/CGFloat(noOfColumns+1))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
