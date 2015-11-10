//
//  ViewController.swift
//  sonar
//
//  Created by Davo on 11/4/15.
//  Copyright © 2015 Pixelbeat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {    
    
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet var CitiesPickerView: UIPickerView!
    
    let gradient:CAGradientLayer? = CAGradientLayer()
    
    var ciudades = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        Revisar como armar lista nueva usando los arrays
        http://www.spritekitlessons.com/troubleshooting-arrays-in-a-property-list-with-swift/
        */

        
        let pathCitiesList = NSBundle.mainBundle().pathForResource("ciudades", ofType: "plist")
        
        ciudades = NSArray(contentsOfFile: pathCitiesList!) as! [String]
        
//        print(ciudades)

    }
    
    override func viewDidAppear(animated: Bool) {
        
        let gradientLayerView: UIView = UIView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
        
        self.gradient?.frame = self.view.bounds
        self.gradient?.colors = [ UIColor(rgba: "#4355D7").CGColor, UIColor(rgba: "#41f3b9").CGColor]
        
        gradientLayerView.layer.insertSublayer(gradient!, atIndex: 0)
        
        gradientLayerView.layer.cornerRadius = 10;
        gradientLayerView.layer.masksToBounds = true;
        
        self.view.layer.insertSublayer(gradientLayerView.layer, atIndex: 0)
        
    }

    func animateLayer(temperatura:Int){
        let toColors: [AnyObject]
        
        switch temperatura {
            case -10...(-5):
                toColors = [UIColor(rgba: "#cb34bd").CGColor, UIColor(rgba: "#4455d7").CGColor]
            case -5...0:
                toColors = [UIColor(rgba: "#f743ae").CGColor, UIColor(rgba: "#41f3b9").CGColor]
            case 0...5:
                toColors = [UIColor(rgba: "#f743ae").CGColor, UIColor(rgba: "#41f3b9").CGColor]
            case 5...10:
                toColors = [UIColor(rgba: "#0faed6").CGColor, UIColor(rgba: "#9238fa").CGColor]
            case 10...15:
                toColors = [UIColor(rgba: "#fb8303").CGColor, UIColor(rgba: "#0fefcd").CGColor]
            case 15...20:
                toColors = [UIColor(rgba: "#fbd103").CGColor, UIColor(rgba: "#fb8303").CGColor]
            case 20...25:
                toColors = [UIColor(rgba: "#fbd103").CGColor, UIColor(rgba: "#fb8303").CGColor]

            default:
                toColors = [UIColor(rgba: "#1804D2").CGColor, UIColor(rgba: "#0091FF").CGColor]
        }

        let fromColors = self.gradient?.colors
        
        self.gradient!.colors = toColors
        
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 2
        animation.removedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        self.gradient?.addAnimation(animation, forKey:"animateGradient")
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ciudades.count
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        let titleData = ciudades[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let miCiudad = ciudades[row]
        
        
        let termometro = TermometroService()
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(miCiudad)&units=metric&appid=9c22249239b970130f70a73fb3c189c4"
        
        termometro.obtenerTemperaturaSegunCiudad(urlString, nombre: miCiudad, callback: { temperatura in
            // Round temperature by casting the rounded number as an Int
            let tempRounded = Int(round(temperatura))
            // Print the result in the label and attach the degree symbol
            self.currentTemperature.text = "\(tempRounded)°"
            self.currentCity.text = miCiudad
            // Animate gradient background
            self.animateLayer(tempRounded)
            NSUserDefaults.standardUserDefaults().setValue(miCiudad, forKey: "ultimaCiudadBuscada")
            NSUserDefaults.standardUserDefaults().synchronize()
        })
        
    }


}

