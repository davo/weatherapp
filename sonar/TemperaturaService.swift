//
//  TemperaturaService.swift
//  PickerViewDemo
//
//  Created by Kevin Belter on 27/10/15.
//  Copyright © 2015 Kevin Belter. All rights reserved.
//

import Foundation

class TermometroService {
    
    func generarURLValida(url: String) -> String {
        
        return url.stringByAddingPercentEncodingWithAllowedCharacters(
            
            NSCharacterSet.URLQueryAllowedCharacterSet())!
        
    }
    
    func obtenerTemperaturaSegunCiudad(urlString: String, nombre: String, callback: Double -> () ) {
        
        let urlValida = generarURLValida(urlString)
        let url = NSURL(string: urlValida)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            
            if let data = NSData(contentsOfURL: url!) {
                
                do {
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    
                    if let temperatura = jsonDictionary["main"]?["temp"] as? Double {
                        
                        dispatch_async(dispatch_get_main_queue()){
                            callback(temperatura)
                        }
                    }
                } catch {
                    //No logro convertir en JSON la data que le pase
                    dispatch_async(dispatch_get_main_queue()){
                        callback(0)
                    }
                }
            } else {
                //No logro descargar la informacion de mi url.
                dispatch_async(dispatch_get_main_queue()){
                    callback(0)
                }
            }
        }
    }
}
