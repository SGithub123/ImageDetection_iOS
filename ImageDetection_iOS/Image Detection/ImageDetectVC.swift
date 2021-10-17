//
//  ImageDetectVC.swift
//  ImageDetection_iOS
//
//  Created by Sanket Bhamare on 17/10/21.
//

import UIKit

class ImageDetectVC: UIViewController {
    
    @IBOutlet weak var imageName_Lbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var selectedImg = String()
    var imagePicker = UIImagePickerController()
    
    var machineModel = MobileNetV2()

    let imgArr = ["heart","send","bottle","zebra","jaguar","instagram","facebook","monkey","panda","redFox","user","comment","tiger","elephant","banana","nature"]
    
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Setup()
    }
    
    func Setup() {
        
        imagePicker.delegate = self
        imgView.image = UIImage(named: imgArr[0])
        
    }
    
    
    @IBAction func UploadImg_BtnTap(_ sender:UIButton) {
        alertFunc()
    }
    
    @IBAction func ShuffleImg_BtnTap(_ sender:UIButton) {
        
        let randomNo = Int.random(in: 0...imgArr.count - 1)
        self.currentIndex = randomNo
        imgView.image = UIImage(named: imgArr[self.currentIndex])
    }
    
    
    @IBAction func DetectImage_BtnTap(_ sender:UIButton) {
        
        // Image Resize
        guard let img = imgView.image,
              let resizedImg = img.resizeTo(size: CGSize(width: 224, height: 224)),
              let buffer = resizedImg.toBuffer() else {
            return
        }
        
        let output = try? machineModel.prediction(image: buffer)
        
        if let output = output {
            imageName_Lbl.text = output.classLabel
        }
    }
    
    
}


extension ImageDetectVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func alertFunc() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:-- ImagePicker delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
