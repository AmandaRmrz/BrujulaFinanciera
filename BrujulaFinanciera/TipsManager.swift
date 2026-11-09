//
//  TipsManager.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import Foundation
import TipKit

//Eventos Globales
struct TipEvents {
    static let registroCreado = Tips.Event(id: "registroCreadoEvent")
}

//Tip 1: Onboarding al crear movimientos (Popover)
struct ConsejoAgregarMovimientoTip: Tip {
    var options: [TipOption] {
        [Tips.MaxDisplayCount(5), Tips.IgnoresDisplayFrequency(true)]
    }
    
    var title: Text { Text("Brújula de Navegación") }
    var message: Text? { Text("Presiona el botón (+) para registrar tus ingresos y gastos diarios y orientar tu presupuesto.") }
    var image: Image? { Image(systemName: "compass.drawing") }
    
    var rules: [Rule] {
        #Rule(TipEvents.registroCreado) { event in
            event.donations.count < 3
        }
    }
}

//Tip 2: Alerta de Desviacion Financiera (Inline View)
struct AlertaDesviacionTip: Tip {
    @Parameter
    static var alertaGastosElevados: Bool = false
    
    var options: [TipOption] {
        [Tips.IgnoresDisplayFrequency(true)]
    }
    
    var title: Text { Text("¡Alerta de Rumbo Financiero!") }
    var message: Text? { Text("Tus gastos han superado el balance disponible. Revisa tus registros por categoría.") }
    var image: Image? { Image(systemName: "exclamationmark.triangle.fill") }
    
    var rules: [Rule] {
        #Rule(Self.$alertaGastosElevados) { $0 == true }
    }
    
    var actions: [Action] {
        Action(id: "entendido", title: "Entendido, revisar")
    }
}

//Tip 3: Filtrado por Categorias
struct FiltradoCategoriaTip: Tip {
    var options: [TipOption] {
        [Tips.MaxDisplayCount(3), Tips.IgnoresDisplayFrequency(true)]
    }
    
    var title: Text { Text("Filtros de Navegación") }
    var message: Text? { Text("Usa las pestañas horizontales para filtrar tus movimientos por categoría.") }
    var image: Image? { Image(systemName: "line.3.horizontal.decrease.circle.fill") }
}
