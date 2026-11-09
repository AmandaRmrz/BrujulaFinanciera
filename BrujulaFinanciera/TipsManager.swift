//
//  TipsManager.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import Foundation
import TipKit

//Tip 1: Basado en Eventos (Popover Flotante)
struct ConsejoGastoFijoTip: Tip {
    static let agregarMovimientoEvent = Tips.Event(id: "agregarMovimientoEvent")
    
    //Ignorar restricciones de frecuencia para pruebas
    var options: [TipOption] {
        [Tips.MaxDisplayCount(10), Tips.IgnoresDisplayFrequency(true)]
    }
    
    var title: Text { Text("Orientación de Gasto") }
    var message: Text? { Text("Has registrado varios movimientos. Te recomendamos categorizar tus gastos recurrentes.") }
    var image: Image? { Image(systemName: "safari.fill") }
    
    var rules: [Rule] {
        #Rule(Self.agregarMovimientoEvent) { event in
            event.donations.count >= 3
        }
    }
    
    var actions: [Action] {
        Action(id: "calibrar", title: "Entendido")
    }
}

//Tip 2: Basado en Parametros de Estado (Vista Inline)
struct AlertaDesviacionTip: Tip {
    @Parameter
    static var requiereBalanceMensual: Bool = false
    
    //Ignorar restricciones de frecuencia para pruebas
    var options: [TipOption] {
        [Tips.IgnoresDisplayFrequency(true)]
    }
    
    var title: Text { Text("Brújula Descalibrada") }
    var message: Text? { Text("Detectamos un volumen alto de registros acumulados. Revisa el balance para mantener el rumbo.") }
    var image: Image? { Image(systemName: "exclamationmark.triangle.fill") }
    
    var rules: [Rule] {
        #Rule(Self.$requiereBalanceMensual) { $0 == true }
    }
}
