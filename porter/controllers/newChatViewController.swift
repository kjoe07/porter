//
//  newChatViewController.swift
//  roomatch
//
//  Created by Yoel Jimenez del Valle on 23/8/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseStorage
import SDWebImage
import CoreData
import Gallery
class newChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, GalleryControllerDelegate {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var sendText: UITextView!
	@IBOutlet weak var bottom: NSLayoutConstraint!
	@IBOutlet weak var top: NSLayoutConstraint!
	@IBOutlet weak var messageHeigth: NSLayoutConstraint!
	@IBOutlet weak var messagewidth: NSLayoutConstraint!
	@IBOutlet weak var profileButton: UIBarButtonItem!
	var chats: [msg]?
	var compi: profile?
	var chatList : [NSManagedObject] = []
	var destinationId: String? //id del chat desde la lista
	var destinationURL: String? //url de la imagen del avatars
	var destinationName: String?
	var otherId: String? //id del otro usuario del chat
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var id: String? //chat id modificado aqui en caso de que venga de lista o de profile
	var url: String?
	var isForo = false
	var gesture = UITapGestureRecognizer()
	var gallery: GalleryController!
	var secondaryDb: Database!
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		sendText.delegate = self
		self.title = "Enviar Mensaje"
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
		self.view.addGestureRecognizer(tapGesture)
		//gesture.addTarget(self, action: #selector(self.goProfile(_:)))
		//profileButton.tag = 10
		Config.tabsToShow = [.imageTab, .cameraTab]		
		if let compi = compi{
			id = "\(requestManager.instance.user.id!)-\(compi.id!)"
			otherId = compi.id!.description
			destinationName = compi.firstName!
			self.title = destinationName
			if let image = compi.image{
				url = Router.baseURLString + image.path.replacingOccurrences(of: "image", with: "/photo")
			}
			//profileButton.target = self
			//self.profileButton.action = #selector(self.goProfile(_:))
		}else{
			
			id = destinationId
			url = destinationURL
			self.title = destinationName
			let idArr = destinationId?.components(separatedBy: "-")
			if let inde = idArr?.index(where:{ $0 != requestManager.instance.user.id!.description }){
				print("the other Id \(idArr![inde])")
				otherId = idArr?[inde]
				self.getUserData(profileId: otherId!)
			}
			//profileButton.target = self
			//self.profileButton.action = #selector(self.goProfile(_:))
		}
		let secondaryOptions = FirebaseOptions(googleAppID: "1:720317912525:ios:38bd44ad53042c89", gcmSenderID: "720317912525")
		secondaryOptions.bundleID = "com.porterClient.app"
		secondaryOptions.apiKey = "AIzaSyCSls1gH4I-qVmeFLsfPN2WgXrxvwwuWFQ"
		secondaryOptions.clientID = "720317912525-0069ak8koqhbtkul9e2hu5kbvkkvrhpe.apps.googleusercontent.com"
		secondaryOptions.databaseURL = "https://porterclient-fd440.firebaseio.com"
		secondaryOptions.storageBucket = "myproject.appspot.com"
		
		if FirebaseApp.app(name: "secondary") == nil {
			FirebaseApp.configure(name: "secondary", options: secondaryOptions)
		}
		
		// Retrieve a previous created named app.
		guard let secondary = FirebaseApp.app(name: "secondary")
			else { return }//assert(false, "Could not retrieve secondary app")  }
		
		// Retrieve a Real Time Database client configured against a specific app.
		secondaryDb = Database.database(app: secondary)
		//self.navigationItem.titleView?.addGestureRecognizer(gesture)
		print("the chat id \(String(describing: id))")
		let query = secondaryDb.reference().child("chat").child(requestManager.instance.active!.id!.description).queryOrderedByValue()//.queryLimited(toLast: 10)
		_ = query.observe(.childAdded, with: {  snapshot in
			let json = JSON(snapshot.value!)
			//print("the json Value \(json)")
			let mensaje = msg(from: json)
			if mensaje.body == "" && mensaje.attachment == 6{
			}else{
				print("the messaje is \(mensaje)")
				if self.chats != nil{
					if !(self.chats?.contains(where: {
						$0.id == mensaje.id
					}))!{
						self.chats?.append(mensaje)
						self.tableView.reloadData()
						let index = IndexPath(row: self.chats!.count - 1, section: 0)
						self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
					}
				}else{
					print("adding the mensjae to chat")
					if self.chats == nil{
						self.chats = []
					}
					self.chats?.append(mensaje)
				}
				self.chats?.sort()
				self.tableView.reloadData()
				let index = IndexPath(row: self.chats!.count - 1, section: 0)
				self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
			}
		})
		sendText.layer.borderWidth = 1.0
		sendText.layer.borderColor = UIColor.gray.cgColor
		sendText.layer.cornerRadius = 5
		sendText.clipsToBounds = true
		//messagewidth.constant = UIScreen.main.bounds.width - (46 * 2)
        // Do any additional setup after loading the view.
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		let vc = segue.destination as! profileVC
//		if let perfil = compi{
//			vc.i = perfil
//		}
    }
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.black
		nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
	}
	@objc func keyboardWasShown(notification: NSNotification) {
		let info = notification.userInfo!
		let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		UIView.animate(withDuration: 0.1, animations: { () -> Void in
			self.bottom.constant = -(keyboardFrame.size.height)//+ 20
			//self.top.constant  = -keyboardFrame.size.height
		})
	}
	@objc func keyboardWasHidden(notification: NSNotification) {
		UIView.animate(withDuration: 0.1, animations: { () -> Void in
			self.bottom.constant = 0
			//self.top.constant = 20//+= keyboardFrame.size.height
		})
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chats?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if chats![indexPath.row].attachment == 6 {
//            if chats![indexPath.row].senderId != requestManager.instance.user.id?.description{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! incomingText
//                if !isForo{
//                    if let url = URL(string: url!){
//                        cell.avatar.sd_setImage(with: url, completed: nil)
//                    }else{
//                        cell.avatar.image = #imageLiteral(resourceName: "icoPerfil")
//                    }
//                    cell.avatar.isUserInteractionEnabled = true
//                    cell.avatar.addGestureRecognizer(gesture)
//                    self.configureAvatar(in: cell)
//                    cell.name.text = chats![indexPath.row].senderName ?? ""
//                }
//                self.removeView(with: 1000, in: cell)
//                self.removeView(with: 2000, in: cell)
//                showOutgoingMessage(text: chats![indexPath.row].body, cell: cell, incoming: true)
//                let body = cell.viewWithTag(2000) as! UILabel
//                body.text = chats![indexPath.row].body
//                return cell
//            }else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! outgoingText
//                self.removeView(with: 1000, in: cell)
//                self.removeView(with: 2000, in: cell)
//                if let imagen = requestManager.instance.user.image{
//                    cell.avatar.sd_setImage(with: URL(string: Router.baseURLString + imagen.path.replacingOccurrences(of: "images", with: "/photo")), completed: nil)
//                }else{
//                    cell.avatar.image = UIImage(named: "Porter")
//                }
//                cell.name.text = chats![indexPath.row].senderName ?? ""
//                self.configureAvatar(in: cell)
//                showOutgoingMessage(text: chats![indexPath.row].body, cell: cell, incoming: false)
//                let body = cell.viewWithTag(2000) as! UILabel
//                body.text = chats![indexPath.row].body
//                return cell
//            }
//        }else{
//            if chats![indexPath.row].senderId != requestManager.instance.user.id?.description{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! incomingImage
//                if let view = cell.viewWithTag(3000){
//                    (view as! UIImageView).sd_cancelCurrentImageLoad()
//                }
//                if !isForo{
//
//                    if let url = url{
//                        if let myurl = URL(string: url){
//                        cell.avatar.sd_setImage(with: myurl, completed: nil)
//                        cell.avatar.sd_setShowActivityIndicatorView(true)
//                        cell.avatar.sd_setIndicatorStyle(.gray)
//                        }else{
//                            cell.avatar.image = #imageLiteral(resourceName: "icoPerfil")
//                        }
//                    }else{
//                        cell.avatar.image = #imageLiteral(resourceName: "icoPerfil")
//                    }
//                    cell.name.text = chats![indexPath.row].senderName ?? ""
//                    cell.avatar.isUserInteractionEnabled = true
//                    cell.avatar.addGestureRecognizer(gesture)
//                }
//                self.configureAvatar(in: cell)
//
//                self.removeView(with: 3000, in: cell)
//                showIncomingMessage(cell: cell, incoming: true)
//                if let urlString = chats![indexPath.row].imageURL{
//                    if let url = URL(string: urlString){
//                        setImage(with: url, in: cell)
//                    }
//                }
//                return cell
//            }else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! outGoingImage
//                if let view = cell.viewWithTag(3000){
//                    (view as! UIImageView).sd_cancelCurrentImageLoad()
//                }
//                if let imagen = requestManager.instance.user.image{
//                    cell.avatar.sd_setImage(with: URL(string: Router.baseURLString + imagen.path.replacingOccurrences(of: "images", with: "/photo")), completed: nil)
//                    cell.avatar.sd_setShowActivityIndicatorView(true)
//                    cell.avatar.sd_setIndicatorStyle(.gray)
//                }else{
//                    cell.avatar.image = #imageLiteral(resourceName: "icoPerfil")
//                }
//                cell.name.text = chats![indexPath.row].senderName ?? ""
//                cell.avatar.sd_cancelCurrentImageLoad()
//                self.configureAvatar(in: cell)
//                if let image = chats![indexPath.row].imagen{
//                    cell.imagen.image = image
//                }else{
//                    self.removeView(with: 1000, in: cell)
//                    let url = URL(string: chats![indexPath.row].imageURL!);    print("the url \(String(describing: url))")
//                    showIncomingMessage(cell: cell, incoming: false)
//                    setImage(with: url!, in: cell)
//                }
//                return cell
//            }
//        }
       //        if chats![indexPath.row].attachment == 6 {
            if chats![indexPath.row].senderId != requestManager.instance.user.id?.description{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! incomingText
                if !isForo{
                    if let url = URL(string: url ?? ""){
                        cell.avatar.sd_setImage(with: url, completed: nil)
                    }else{
                        cell.avatar.image = UIImage(named: "Porter")
                    }
                    cell.avatar.isUserInteractionEnabled = true
                    cell.avatar.addGestureRecognizer(gesture)
                    self.configureAvatar(in: cell)
                    cell.name.text = chats![indexPath.row].senderName ?? ""
                }
                self.removeView(with: 1000, in: cell)
                self.removeView(with: 2000, in: cell)
                showOutgoingMessage(text: chats![indexPath.row].body, cell: cell, incoming: true)
                let body = cell.viewWithTag(2000) as! UILabel
                body.text = chats![indexPath.row].body
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! outgoingText
                self.removeView(with: 1000, in: cell)
                self.removeView(with: 2000, in: cell)
                if let imagen = requestManager.instance.user.image{
                    cell.avatar.sd_setImage(with: URL(string: Router.baseURLString + imagen.path.replacingOccurrences(of: "images", with: "/photo")), completed: nil)
                }else{
                    cell.avatar.image = UIImage(named: "Porter")
                }
                cell.name.text = chats![indexPath.row].senderName ?? ""
                self.configureAvatar(in: cell)
                showOutgoingMessage(text: chats![indexPath.row].body, cell: cell, incoming: false)
                let body = cell.viewWithTag(2000) as! UILabel
                body.text = chats![indexPath.row].body
                return cell
            }
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if chats![indexPath.row].attachment == 2{
			return 320
		}else{
			let constraintRect = CGSize(width: 0.66 * self.view.frame.width,	height: .greatestFiniteMagnitude)
			return chats![indexPath.row].body.boundingRect(with: constraintRect,options: .usesLineFragmentOrigin,attributes: [.font: UIFont.systemFont(ofSize: 18)],context: nil).height + 50
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.view.endEditing(true)
	}
	func showIncomingMessage(cell: UITableViewCell, incoming: Bool) {
		let width: CGFloat = 0.66 * cell.contentView.frame.width
		let height: CGFloat = 290//cell.contentView.frame.height - 20//320//width / 0.75
		let maskView = BubbleView()
		//maskView.isIncoming = true
		maskView.backgroundColor = .clear
		maskView.frame.size = CGSize(width: width, height: height)
		maskView.isIncoming = incoming
		let imageView = UIImageView()
		imageView.frame.size = CGSize(width: width, height: height)
		imageView.frame.origin.y =  cell.contentView.frame.origin.y + 18
		imageView.center.x = cell.contentView.center.x
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.mask = maskView
		imageView.tag = 3000
		cell.contentView.addSubview(imageView)
	}
	
	func showOutgoingMessage(text: String, cell: UITableViewCell, incoming: Bool) {
		let label =  UILabel()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 18)
		label.textColor = .black
		label.text = text
		let constraintRect = CGSize(width: 0.66 * cell.contentView.frame.width,height: .greatestFiniteMagnitude)
		let boundingBox = text.boundingRect(with: constraintRect,options: .usesLineFragmentOrigin,attributes: [.font: label.font],context: nil)
		label.frame.size = CGSize(width: ceil(boundingBox.width),height: ceil(boundingBox.height))
		let bubbleSize = CGSize(width: label.frame.width + 28,height: label.frame.height + 20)
		let bubbleView = BubbleView()
		bubbleView.isIncoming = incoming
		bubbleView.tag = 1000
		bubbleView.frame.size = bubbleSize
		bubbleView.backgroundColor = .clear
		if incoming{
			bubbleView.frame.origin.x = (cell as! incomingText).avatar.frame.maxX + 10
			bubbleView.frame.origin.y = (cell as! incomingText).avatar.frame.minY + 18
			label.frame.origin.x = bubbleView.frame.origin.x + 15
			label.frame.origin.y = bubbleView.frame.origin.y + 10
		}else{
			let cell1 = (cell as! outgoingText)
			bubbleView.frame.origin.x = cell1.frame.width - (cell1.avatar.frame.width + 30 + bubbleSize.width)
			bubbleView.frame.origin.y = (cell as! outgoingText).avatar.frame.minY + 18
			label.frame.origin.x = bubbleView.frame.origin.x + 15
			label.frame.origin.y = bubbleView.frame.origin.y + 10
		}
		cell.contentView.addSubview(bubbleView)
		label.tag = 2000
		cell.contentView.addSubview(label)
	}
	@IBAction func handleTap(sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
	}
	@IBAction func pickPhotoAction(_ sender: Any) {
		gallery = GalleryController()
		gallery.delegate = self
		present(gallery, animated: true, completion: nil)
	}
	
//	func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {//image
//		print(" sent to uploading image")
//		self.uploadImage(image, completion: { url in
//			if url == nil{
//				self.showError(tittle: "No se pudo enviar la foto", error: "Verifique su conexion a internet")
//			}else{
//				print("making the upload")
//				let current = Constants.refs.databaseChats.child(self.id!) //ref.child("\(message.sender.id)-\(String(self.compi!.id!))")
//				let messageref = current.childByAutoId().key
//				let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
//				let attachmet = ["name": "\(imageName).jpeg","url": url?.absoluteString]
//				let mMessage = ["attachmentType" : 2,"attachment": attachmet,"body" : "","date" :Date().millisecondsSince1970,"delivered" : false,"id" : messageref,"loaded" : true, "managed" :false, "recipientId" : self.otherId!, "selected" : false,"senderId" : requestManager.instance.user.id!.description, "senderName" : requestManager.instance.user.firstName!,"sent" : true, "valid" : true] as [String : Any]
//				let message = msg(image: image, senderId: requestManager.instance.user.id!.description, senderName: requestManager.instance.user.firstName!, recipientId: self.otherId!, id: messageref)
//				current.child(messageref).setValue(mMessage)
//				self.chats?.append(message)
//				self.tableView.reloadData()
//				let index = IndexPath(row: self.chats!.count - 1, section: 0)
//				self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
//			}
//		})
//		dismiss(animated: true)
//	}
	
	private func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
		guard let scaledImage = image.scaledToSafeUploadSize, let data = UIImageJPEGRepresentation(scaledImage, 0.4) else { completion(nil); return }
		let filePath = "RooMatch"
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"
		let storageRef = Storage.storage().reference()
		let uuid = UUID().uuidString ;print("the uuid is \(uuid)")
		let date = String(Date().timeIntervalSince1970) ; print("the date is \(date)")
		let imageName = [uuid,date ].joined(separator: "-")+".jpge" ; print("the image Name \(imageName)")
		storageRef.child(filePath).child("Image").child(imageName).putData(data, metadata: metadata,completion: {(metaData,error) in
			if error == nil {
				storageRef.child(filePath).child("Image").child(imageName).downloadURL(completion: { (url, error) in
					print("the url is", url ?? "no hay url", error ?? "no hay error");completion(url)
				})
			}else{
				print(error!.localizedDescription)
				completion(nil)
			}
		})
	}
	func readUserFromCD(){
//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
//		let managedContext = appDelegate.persistentContainer.viewContext
//		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Chat")
//		do {
//			self.chatList = try managedContext.fetch(fetchRequest)
//			print(self.chatList.count)
//		} catch {
//			print("Could not fetch. \(error.localizedDescription)")
//		}
	}
	private func insertNewMessage(_ message: msg) {
		let current = Constants.refs.databaseChats.child(id!)
		let messageref = current.childByAutoId().key
		let myMessage = ["attachmentType" : 6,"body" : message.body,"date" : message.date!,"delivered" : false,"id" : messageref,"loaded" : true, "managed" :false, "recipientId" : message.recipientId!, "selected" : false,"senderId" : message.senderId!, "senderName" : message.senderName!,"sent" : true, "valid" : true] as [String : Any]
		current.child(messageref).setValue(myMessage)
	}
	@IBAction func sendTextAction(_ sender: Any) {
		if sendText.text != ""{
			let current = secondaryDb.reference().child("chat").child(requestManager.instance.active!.id!.description)
			let messageref = current.childByAutoId().key
			let newMessage = msg(body: sendText.text!, senderName: requestManager.instance.user.firstName!, senderId: requestManager.instance.user.id!.description, recipientId: "0", id: messageref)
			let myMessage = ["attachmentType" : 6,"body" : newMessage.body,"date" : newMessage.date!,"delivered" : false,"id" : messageref,"loaded" : true, "managed" :false, "recipientId" : newMessage.recipientId!, "selected" : false,"senderId" : newMessage.senderId!, "senderName" : newMessage.senderName!,"sent" : true, "valid" : true] as [String : Any]
			current.child(messageref).setValue(myMessage)
			self.sendText.text = ""
			if chats == nil {
				chats = []
			}
			self.chats?.append(newMessage)
			self.tableView.reloadData()
			let index = IndexPath(row: self.chats!.count - 1, section: 0)
			self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
			messageHeigth.constant = 59
		}
	}
	@IBAction func close(sender: Any){
		self.dismiss(animated: true, completion: {});
		self.navigationController?.popViewController(animated: true);
	}
	func removeView(with tag: Int, in cell: UITableViewCell){
		if let label = cell.viewWithTag(tag){
			label.removeFromSuperview()
		}
	}
	func configureAvatar(in cell: UITableViewCell){
		(cell as! avatarCell).avatar.layer.borderWidth = 1.0
		(cell as! avatarCell).avatar.layer.borderColor = darkBlue.cgColor
	}
	func setAvatar(in cell: avatarCell, with url: String){
		cell.avatar.sd_setImage(with: URL(string: url), completed: nil)
		cell.avatar.sd_setShowActivityIndicatorView(true)
		cell.avatar.sd_setIndicatorStyle(.gray)
	}
	func setImage(with url: URL, in cell: UITableViewCell){
		let imagen = cell.viewWithTag(3000) as! UIImageView
		imagen.sd_setImage(with: url, completed: nil)
		imagen.sd_setShowActivityIndicatorView(true)
		imagen.sd_setIndicatorStyle(.gray)
		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
		imagen.addGestureRecognizer(gesture)
		imagen.isUserInteractionEnabled = true
	}
	@IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
		let imageView = sender.view as! UIImageView
		let newImageView = UIImageView(image: imageView.image)
		newImageView.frame = UIScreen.main.bounds
		newImageView.backgroundColor = .black
		newImageView.contentMode = .scaleAspectFit
		newImageView.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
		newImageView.addGestureRecognizer(tap)
		self.view.addSubview(newImageView)
		self.navigationController?.isNavigationBarHidden = true
		//self.tabBarController?.tabBar.isHidden = true
	}
	@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
		self.navigationController?.isNavigationBarHidden = false
		//self.tabBarController?.tabBar.isHidden = false
		sender.view?.removeFromSuperview()
	}
	func textViewDidChange(_ textView: UITextView) {
			let constraintRect = CGSize(width: sendText.frame.width,	height: .greatestFiniteMagnitude)
			self.messageHeigth.constant = textView.text!.boundingRect(with: constraintRect,options: .usesLineFragmentOrigin,attributes: [.font: sendText.font!],context: nil).height + 36		
	}
//	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//		let constraintRect = CGSize(width: sendText.frame.width,	height: .greatestFiniteMagnitude)
//		//return chats![indexPath.row].body.boundingRect(with: constraintRect,options: .usesLineFragmentOrigin,attributes: [.font: UIFont.systemFont(ofSize: 18)],context: nil).height + 50
//		self.messageHeigth.constant = sendText.text!.boundingRect(with: constraintRect,options: .usesLineFragmentOrigin,attributes: [.font: sendText.font!],context: nil).height + 36
//		return true
//	}
	func readUserProperties(userId: String, completion: @escaping (String?,String?)-> Void){
		Constants.refs.databaseRoot.child(userId).observeSingleEvent(of: .value, with: {snap in
			print(snap.value as Any)
			let da = snap.value as! [String: Any]
			guard let name = da["name"] as? String else { return completion(nil,nil)}
			guard let preurl = da["image"] as? String else{ return completion(nil,nil)}
			completion(name,preurl)
			//name = da["name"] as? String
			//preurl =
			//self?.setChats(id: id, name: name!, message: message!, preurl: preurl!, key: key!)
		})
	}
	func getUserData(profileId: String){
		routeClient.instance.getProfile(by: profileId, success: {data in
			do{
				let decoder  = try JSONDecoder().decode(profile.self, from: data)
				self.compi = decoder
			}catch{
				print(error.localizedDescription)
			}
		}, failure: {error in
			print(error.localizedDescription)
		})
	}
	func galleryControllerDidCancel(_ controller: GalleryController) {
		controller.dismiss(animated: true, completion: nil)
		gallery = nil
	}
	
	func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
		controller.dismiss(animated: true, completion: nil)
		gallery = nil
	}
	func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
		controller.dismiss(animated: true, completion: nil)
		Image.resolve(images: images, completion: { [weak self] resolvedImages in
			if let imagen = resolvedImages.first{
				print("there is an image in didselect \(String(describing: imagen))")
				if let self = self{
					self.uploadImage(imagen!, completion: { url in
						if url == nil{
							self.showError(tittle: "No se pudo enviar la foto", error: "Verifique su conexion a internet")
						}else{
							print("making the upload")
							let current = Constants.refs.databaseChats.child(self.id!) //ref.child("\(message.sender.id)-\(String(self.compi!.id!))")
							let messageref = current.childByAutoId().key
							let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
							let attachmet = ["name": "\(imageName).jpeg","url": url?.absoluteString]
							let mMessage = ["attachmentType" : 2,"attachment": attachmet,"body" : "","date" :Date().millisecondsSince1970,"delivered" : false,"id" : messageref,"loaded" : true, "managed" :false, "recipientId" : self.otherId!, "selected" : false,"senderId" : requestManager.instance.user.id!.description, "senderName" : requestManager.instance.user.firstName!,"sent" : true, "valid" : true] as [String : Any]
							let message = msg(image: imagen!, senderId: requestManager.instance.user.id!.description, senderName: requestManager.instance.user.firstName!, recipientId: self.otherId!, id: messageref)
							current.child(messageref).setValue(mMessage)
							self.chats?.append(message)
							self.tableView.reloadData()
							let index = IndexPath(row: self.chats!.count - 1, section: 0)
							self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.top, animated: true)
						}
					})
				}
			}else{
				print("no image")
			}
		})
		gallery = nil
	}
	
	func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
		Image.resolve(images: images, completion: {  resolvedImages in
			if resolvedImages.first != nil{
				print("there is an image")
				//self?.ico.image = image
			}else{
				print("no image")
			}
		})
	}
	
}

