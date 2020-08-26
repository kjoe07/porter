//
//  infoViewController.swift
//  porter
//
//  Created by yoel jimenez del valle on 11/1/18.
//  Copyright © 2018 Yoel Jimenez del Valle. All rights reserved.
//

import UIKit

class infoViewController: UIViewController {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var texto: UILabel!
    var id: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = id {
            if id == 0 {
                self.titulo.text = "Solo conductor"
                self.texto.text = "El conductor llegará al punto de origen con su  furgoneta y tú serás la persona responsable de  cargar y descargar los objetos que deseas  transportar. Puedes pedir ayuda a amigos para  que te echen una mano, ya que la ayuda del  conductor en carga y descarga no está incluida  en esta opción. En porter incluimos 10 min gratis  para que cargues y descargues tus objetos  en la furgoneta (divíde los min como quieras) a  partir del minuto 10 en esta opción el precio del  minuto extra es de 0,75 €. El tiempo del trayecto  no influirá en el precio final, indepedicntemente   del tráfico. Te recomendamos que tengas todo  preparado en el punto de origen para que cuando  llegue la furgoneta, solamente sea subir los  objetos a la furgo. Podrás cargar en la furgoneta  todo lo que quieras hasta llenarla, nuestras  furgonetas tienen un largo de 3,10 m y una altura  de 2,20 m. Podrás llevar todo lo que entre dentro  de estas medidas, y recuerda que podrás estar  cargando y descargando todo el tiempo que  necesites, así que no te agobies si tienes que  llevar muchas cosas, incluimos 10´pero te puedes  extender todo lo que quieras, ya que nuestro  conductor te va a esperar y sólo cobramos  0,75€ por min extra."
            }else if id == 1 {
                self.titulo.text = "Conductor / Porter"
                self.texto.text = "El conductor llegará al punto de origen con su  furgoneta y tú serás la persona responsable de  cargar y descargar los objetos que deseas  transportar. Puedes pedir ayuda a amigos para  que te echen una mano, ya que la ayuda del  conductor en carga y descarga no está incluida  en esta opción. En porter incluimos 10 min gratis  para que cargues y descargues tus objetos  en la furgoneta (divíde los min como quieras) a  partir del minuto 10 en esta opción el precio del  minuto extra es de 0,75 €. El tiempo del trayecto  no influirá en el precio final, indepedicntemente   del tráfico. Te recomendamos que tengas todo  preparado en el punto de origen para que cuando  llegue la furgoneta, solamente sea subir los  objetos a la furgo. Podrás cargar en la furgoneta  todo lo que quieras hasta llenarla, nuestras  furgonetas tienen un largo de 3,10 m y una altura  de 2,20 m. Podrás llevar todo lo que entre dentro  de estas medidas, y recuerda que podrás estar  cargando y descargando todo el tiempo que  necesites, así que no te agobies si tienes que  llevar muchas cosas, incluimos 10´pero te puedes  extender todo lo que quieras, ya que nuestro  conductor te va a esperar y sólo cobramos  0,75€ por min extra."
            }else{
                self.titulo.text = "Dos Porters"
                self.texto.text = "El conductor llegará al punto de origen con su  furgoneta y tú serás la persona responsable de  cargar y descargar los objetos que deseas  transportar. Puedes pedir ayuda a amigos para  que te echen una mano, ya que la ayuda del  conductor en carga y descarga no está incluida  en esta opción. En porter incluimos 10 min gratis  para que cargues y descargues tus objetos  en la furgoneta (divíde los min como quieras) a  partir del minuto 10 en esta opción el precio del  minuto extra es de 0,75 €. El tiempo del trayecto  no influirá en el precio final, indepedicntemente   del tráfico. Te recomendamos que tengas todo  preparado en el punto de origen para que cuando  llegue la furgoneta, solamente sea subir los  objetos a la furgo. Podrás cargar en la furgoneta  todo lo que quieras hasta llenarla, nuestras  furgonetas tienen un largo de 3,10 m y una altura  de 2,20 m. Podrás llevar todo lo que entre dentro  de estas medidas, y recuerda que podrás estar  cargando y descargando todo el tiempo que  necesites, así que no te agobies si tienes que  llevar muchas cosas, incluimos 10´pero te puedes  extender todo lo que quieras, ya que nuestro  conductor te va a esperar y sólo cobramos  0,75€ por min extra."
            }
        }
       
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
    @IBAction func close(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
