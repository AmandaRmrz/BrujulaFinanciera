//
//  TipsManager.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import Foundation
import TipKit

// MARK: - Modelo de Datos Persistente
struct MovimientoFinanciero: Identifiable, Codable {
    var id = UUID()
    var concepto: String
    var monto: Double
    var fecha: Date = Date()
    var categoria: String
}

// MARK: - Tip 1: Basado en Eventos (Popover)
struct ConsejoGastoFijoTip: Tip {
    static let agregarMovimientoEvent = Tips.Event(id: "agregarMovimientoEvent")
    
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
