//
//  sliderViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 24/9/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class sliderViewController: UIViewController, UIScrollViewDelegate {
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imagen: UIImageView!
	@IBOutlet weak var empezarButton: UIButton!
	@IBOutlet weak var pagina: UIPageControl!
    @IBOutlet weak var atras: UIImageView!
    @IBOutlet weak var adelante: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		let img1 = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		img1.image = UIImage(named: "slide1")
		let img2 = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		img2.image = UIImage(named: "slide2")
		let img3 = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width * 2, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		img3.image = UIImage(named: "slide3")
		scrollView.addSubview(img1)
		scrollView.addSubview(img2)
		scrollView.addSubview(img3)
		scrollView.contentSize = CGSize(width:UIScreen.main.bounds.width * 3, height:self.scrollView.frame.height)
		self.scrollView.delegate = self
		self.pagina.currentPage = 0
        empezarButton.setBorder(color: darkBlue, width: 0, radius: 19)
        //pagina.isHidden = true
        empezarButton.isHidden = true
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
//        // Test the offset and calculate the current page after scrolling ends
//        let pageWidth:CGFloat = scrollView.frame.width
//        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//        // Change the indicator
//        self.pagina.currentPage = Int(currentPage);
////        if pagina.currentPage == 2 {
////            empezarButton.isHidden = false
////        }else{
////
////        }
//        // Change the text accordingly
//        switch pagina.currentPage {
//        case 0:
//            atras.isHidden = true
//            empezarButton.isHidden = true
//            adelante.isHidden = false
//        case 1:
//            atras.isHidden = false
//            empezarButton.isHidden = true
//            adelante.isHidden = false
//        case 2:
//            atras.isHidden = false
//            empezarButton.isHidden = false
//            adelante.isHidden = true
//        default:
//            break
//        }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pagina.currentPage = Int(currentPage);
        //        if pagina.currentPage == 2 {
        //            empezarButton.isHidden = false
        //        }else{
        //
        //        }
        // Change the text accordingly
        switch pagina.currentPage {
        case 0:
            atras.isHidden = true
            empezarButton.isHidden = true
            adelante.isHidden = false
        case 1:
            atras.isHidden = false
            empezarButton.isHidden = true
            adelante.isHidden = false
        case 2:
            atras.isHidden = false
            empezarButton.isHidden = false
            adelante.isHidden = true
        default:
            break
        }
    }
	@IBAction func begin(_ sender: Any){
		performSegue(withIdentifier: "begin", sender: self)
	}

}
