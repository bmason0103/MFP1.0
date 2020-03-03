//
//  cityViewController.swift
//  MyFinal
//
//  Created by Brittany Mason on 2/29/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class CityViewController : UIViewController {
    //MARK: Set up Outlets
    @IBOutlet weak var cityPicture: CityViewController!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //MARK: Setup Variables
    var nameOfSelectedCity = ""
    var lat = 0.0
    var log = 0.0
    var pictureStruct : [PhotoParser]?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var personvar: Person?
    var pics: Photos?

    var pictureStructs: [NSManagedObject] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLabel.text = nameOfSelectedCity
//        getPhotosFromFlickr ()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
           }
           
           let managedContext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Photos")
           
           do {
               pictureStructs = try managedContext.fetch(fetchRequest)
           } catch let error as NSError {
               print("Could not fetch. \(error), \(error.userInfo)")
           }
       }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getPhotosFromFlickr () {
           print("'New Collection' button pressed")
           activityIndicatorStart()
//           newCollectionButton.isEnabled = false

           helperTasks.downloadPhotos { (pictureInfo, error) in
               if let pictureInfo = pictureInfo {
                   self.pictureStruct = pictureInfo.photos.photo
                   self.storePhotos(self.pictureStruct!, forPin: self.personvar!)
                   print(pictureInfo)

                   DispatchQueue.main.async {
                       self.activityIndicatorStop()
                       
                    guard self.personvar != nil else {
                           return
                       }
                    self.setupFetchedResultControllerWith(self.pics!)
//                       self.collectionView.reloadData()

                   }
               } else {
                   DispatchQueue.main.async {
                       self.displayAlert(title: "Error", message: "Unable to get student locations.")
                   }
                   print(error as Any)
               }

           }
//           self.CityViewController.reloadData()
       }
    
    
    private func setupFetchedResultControllerWith(_ city: Photos) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Photos")
        
        // Start the fetched results controller
        let error: NSError?
        do {
                   pictureStructs = try managedContext.fetch(fetchRequest)
               } catch let error as NSError {
                   print("Could not fetch. \(error), \(error.userInfo)")
               }
        
        if let error = error {
            print("\(#function) Error performing initial fetch: \(error)")
        }
    }
    
    private func storePhotos(_ photos: [PhotoParser], forPin: Person) {
           func showErrorMessage(msg: String) {
               showInfo(withTitle: "Error", withMessage: msg)
           }
    for photo in photos {
            DispatchQueue.main.async {
                if let url = photo.url {
                    _ = Photos(title: photo.title, imageUrl: url, cityName: Person, context: NSManagedObjectContext)
                }
            }
        }
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: managedContext)!
        let picurl = NSManagedObject(entity: entity, insertInto: managedContext)
        picurl.setValue(name, forKeyPath: "urlimage")
        print (picurl)
        
        do {
            try managedContext.save()
            pictureStructs.append(pics!)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func activityIndicatorStart () {
        print("act ind working")
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func activityIndicatorStop () {
        activityIndicator.stopAnimating()
    }
    
    
}
