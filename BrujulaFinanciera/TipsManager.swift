//
//  TipsManager.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import Foundation

// MARK: - Modelo de Datos Persistente
struct MovimientoFinanciero: Identifiable, Codable {
    var id = UUID()
    var concepto: String
    var monto: Double
    var fecha: Date = Date()
    var categoria: String
}
