//
//  ViewController.swift
//  workTimer
//
//  Created by shiba on 2018/09/15.
//  Copyright © 2018年 shiba. All rights reserved.
//

import UIKit
import Firebase
import SpringIndicator

class ViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    var screenSize: CGRect!
    var mailField: UITextField!
    var pwField: UITextField!
    var errorLabel: UITextField!
    var overlay : UIView?

    override func viewWillAppear(_ animated: Bool) {
        self.configureObserver()
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user != nil) {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.moveStoryboard(name: "Timer")
                }
            }
        }
        //オートフォーカス
        mailField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        screenSize = UIScreen.main.bounds
        //背景画面
        configBackground()
        //Form設定
        configFrom()
    }

    func postLogin(){
        guard let email = mailField.text,
            let password = pwField.text else {
                return
        }
        if email.isEmpty && password.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = "※メールアドレスとパスワードが入力されていません。"
            errorLabel.sizeToFit()
            mailField.becomeFirstResponder()
            return
        }
        //overレイ
        configOverlay()

        //認証
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.errorLabel.isHidden = false
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.sizeToFit()
                self.overlay?.removeFromSuperview()
                return
            }
            // 成功したので、スレッドを表示する.
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.moveStoryboard(name: "Timer")
            }
        }
    }
    func configOverlay(){
        self.overlay = UIView()
        let indicator = SpringIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        indicator.lineColors = [.cyan, .gray, .magenta, .yellow]
        indicator.lineWidth = 8
        indicator.center = view.center
        self.overlay?.addSubview(indicator)
        indicator.start()
        
        self.overlay?.frame = CGRect(x:0, y:0, width:view.bounds.width, height:view.bounds.height)
        self.overlay?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.addSubview(self.overlay!)
    }
    //Form設定
    func configFrom(){
        var bp = screenSize.height/2.5
        let title = UILabel()
        title.frame = CGRect(x:20, y:bp, width:screenSize.width, height:14)
        title.text = "WorkTimer Login"
        title.font = UIFont.systemFont(ofSize: 40)
        title.textColor = UIColor.white
        title.sizeToFit()
        self.view.addSubview(title)
        
        mailField = UITextField()
        bp = bp + title.layer.bounds.height + 10
        mailField.frame = CGRect(x:20, y:bp, width:screenSize.width/2, height:40)
        mailField.font = UIFont.systemFont(ofSize: 18)
        mailField.textColor = UIColor.white
        mailField.backgroundColor = UIColor.clear
        mailField.returnKeyType = .done
        mailField.delegate = self
        mailField.autocorrectionType = .no
        mailField.autocapitalizationType = .none
        mailField.spellCheckingType = .no
        mailField.attributedPlaceholder = NSAttributedString(string: "メールアドレス", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        mailField.borderStyle = .roundedRect
        mailField.layer.cornerRadius = 5.0
        mailField.layer.borderColor = UIColor.white.cgColor
        mailField.layer.borderWidth = 1.0
        self.view.addSubview(mailField)
        
        //パスワード
        pwField = UITextField()
        bp = bp + mailField.layer.bounds.height + 10
        pwField.frame = CGRect(x:20, y:bp, width: screenSize.width/2, height:40 )
        pwField.font = UIFont.systemFont(ofSize: 18)
        pwField.textColor = UIColor.white
        pwField.isSecureTextEntry = true
        pwField.returnKeyType = .done
        pwField.delegate = self
        pwField.backgroundColor = UIColor.clear
        pwField.attributedPlaceholder = NSAttributedString(string: "パスワード", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        pwField.borderStyle = .roundedRect
        pwField.layer.cornerRadius = 5.0
        pwField.layer.borderColor = UIColor.white.cgColor
        pwField.layer.borderWidth = 1.0
        pwField.layer.masksToBounds = true
        self.view.addSubview(pwField)
        
        //Message
        errorLabel = UITextField()
        bp = bp + mailField.layer.bounds.height + 10
        errorLabel.frame = CGRect(x:20, y:bp, width: screenSize.width/2, height:40 )
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.white
        errorLabel.text = "error"
        errorLabel.sizeToFit()
        self.view.addSubview(errorLabel)
        
    }
    
    //背景画面
    func configBackground(){
        //グラデーションレイヤーだけ先
        let gradatLayer = CAGradientLayer()
        gradatLayer.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height)
        gradatLayer.colors = [
            UIColor.magenta.cgColor,
            UIColor.cyan.cgColor,
        ]
        gradatLayer.startPoint = CGPoint(x: 0.0, y: 0.95)
        gradatLayer.endPoint = CGPoint(x: 1.0, y: 0.05)
        gradatLayer.opacity = 0.6
        self.view.layer.addSublayer(gradatLayer)
        
        //FirebaseStorage
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "loginvisual/bg-login.jpg")
        pathReference.getData(maxSize: 1 * 1024 * 1024){ data, error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                let image = UIImage(data: data!)
                // image が 元画像のUIImage
                let ciImage:CIImage = CIImage(image:image!)!
                // カラーエフェクトを指定してCIFilterをインスタンス化.
                let mySharpFilter = CIFilter(name:"CIColorMonochrome")
                mySharpFilter!.setValue(ciImage, forKey: kCIInputImageKey)
                mySharpFilter!.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
                mySharpFilter!.setValue(NSNumber(value: 1.0), forKey: "inputIntensity")

                
                // フィルターを通した画像をアウトプット.
                //修正前let image2 = UIImage(CIImage: mySharpFilter!.outputImage!)
                let context = CIContext()
                let cgImage = context.createCGImage(mySharpFilter!.outputImage!,from: mySharpFilter!.outputImage!.extent)
                let image2 = UIImage(cgImage: cgImage!)
                
                // Data for "images/island.jpg" is returned
                let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                backgroundImage.image = image2
                backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
                self.view.insertSubview(backgroundImage, at: 0)
            }
        }
    }
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
            
        })
    }
    
}

extension ViewController: UITextFieldDelegate{
    //returnの拡張
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mailField {
            pwField.becomeFirstResponder()
        }else if textField == pwField{
            textField.resignFirstResponder()
            self.postLogin()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ユーザがキーボード以外の場所をタップすると、キーボードを閉じる
        self.view.endEditing(true)
    }
    
    
}


