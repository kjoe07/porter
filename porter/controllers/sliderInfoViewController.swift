//
//  sliderInfoViewController.swift
//  porter
//
//  Created by Yoel Jimenez del Valle on 11/13/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class sliderInfoViewController: UIViewController {
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var page: UIPageControl!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(self.pageChanged(_:))), userInfo: nil, repeats: true)
        //labelInfo.setBorder(color: .lightGray, width: 2.0, radius: 12.0)
        labelInfo.text = "Todas nuestras furgos tienen 3,10 de largo y 2,20 de alto"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    @IBAction func pageChanged(_ sender: UIPageControl) {
        if page.currentPage < page.numberOfPages - 1{
            page.currentPage += 1
        }else{
            page.currentPage = 0
        }
        switch page.currentPage {
        case 0:
            labelInfo.text = "Todas nuestras furgos tienen 3,10 de largo y 2,20 de alto"
        case 1:
            labelInfo.text = "El tiempo de trayecto en ningún caso influirá en el precio (ej. tráfico)"
        case 2:
            labelInfo.text = "En Origen-Destino tendrás 10’ de carga y descarga gratuitos"
        case 3:
            labelInfo.text = "Hacemos desde pequeños Portes hasta mudanzas completas. No nos preocupa lo que tengas que mover, ni el tiempo necesario para ello ni la distancia."
        case 4:
            labelInfo.text = "Llevamos paqueterías, muebles (camas, sofás, armarios, mesas...) electrodomésticos (lavadoras, neveras,...) material de construcción, elementos de decoración, y todo lo que imagines, siempre que entre en una de nuestras furgos 😀"
        default:
            break
        }
    }
    
}
