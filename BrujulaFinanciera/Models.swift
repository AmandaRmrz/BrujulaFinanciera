//
//  Models.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import Foundation
import SwiftUI

enum TipoMovimiento: String, Codable, CaseIterable, Identifiable {
    case gasto = "Gasto"
    case ingreso = "Ingreso"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .gasto: return .red
        case .ingreso: return .green
        }
    }
}

struct CategoriaFinanciera: Identifiable, Codable, Hashable {
    var id = UUID()
    var nombre: String
    var icono: String // SF Symbol
    var esPredeterminada: Bool = false
    
    static let predeterminadas: [CategoriaFinanciera] = [
        CategoriaFinanciera(nombre: "Alimentación", icono: "cart.fill", esPredeterminada: true),
        CategoriaFinanciera(nombre: "Servicios", icono: "bolt.fill", esPredeterminada: true),
        CategoriaFinanciera(nombre: "Transporte", icono: "car.fill", esPredeterminada: true),
        CategoriaFinanciera(nombre: "Sueldo", icono: "dollarsign.circle.fill", esPredeterminada: true),
        CategoriaFinanciera(nombre: "Otros", icono: "ellipsis.circle.fill", esPredeterminada: true)
    ]
}

struct MovimientoFinanciero: Identifiable, Codable {
    var id = UUID()
    var concepto: String
    var monto: Double
    var fecha: Date = Date()
    var categoria: String
    var tipo: TipoMovimiento = .gasto
}
