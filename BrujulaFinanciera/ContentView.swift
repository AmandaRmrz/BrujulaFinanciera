//
//  ContentView.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import SwiftUI

private let consejoGasto = ConsejoGastoFijoTip()

struct ContentView: View {
    @AppStorage("movimientos_data") private var movimientosData: Data = Data()
    @State private var movimientos: [MovimientoFinanciero] = []
    
    @State private var mostrarModal = false
    @State private var concepto = ""
    @State private var monto = ""
    @State private var categoria = "Alimentación"
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Movimientos Registrados")) {
                    if movimientos.isEmpty {
                        ContentUnavailableView(
                            "Sin Registros",
                            systemImage: "tray",
                            description: Text("Agrega tu primer movimiento presionando el botón (+).")
                        )
                    } else {
                        ForEach(movimientos) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.concepto).font(.headline)
                                    Text(item.categoria).font(.subheadline).foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("$\(item.monto, specifier: "%.2f")")
                                    .fontWeight(.bold)
                            }
                        }
                        .onDelete(perform: eliminarMovimiento)
                    }
                }
            }
            .navigationTitle("Brújula Financiera")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { mostrarModal = true }) {
                        Image(systemName: "plus")
                    }
                    .popoverTip(consejoGasto, arrowEdge: .top)
                }
            }
            .sheet(isPresented: $mostrarModal) {
                formularioAgregar
            }
            .onAppear(perform: cargarDatos)
        }
    }
    
    private func guardarMovimiento() {
        guard let montoDouble = Double(monto), !concepto.isEmpty else { return }
        let nuevo = MovimientoFinanciero(concepto: concepto, monto: montoDouble, categoria: categoria)
        movimientos.append(nuevo)
        persistirDatos()
        concepto = ""
        monto = ""
        mostrarModal = false
        
        Task {
            await ConsejoGastoFijoTip.agregarMovimientoEvent.donate()
        }
    }
    
    private func eliminarMovimiento(offsets: IndexSet) {
        movimientos.remove(atOffsets: offsets)
        persistirDatos()
    }
    
    private func persistirDatos() {
        if let encoded = try? JSONEncoder().encode(movimientos) {
            movimientosData = encoded
        }
    }
    
    private func cargarDatos() {
        if let decoded = try? JSONDecoder().decode([MovimientoFinanciero].self, from: movimientosData) {
            movimientos = decoded
        }
    }
    
    private var formularioAgregar: some View {
        NavigationStack {
            Form {
                TextField("Concepto (ej. Almuerzo)", text: $concepto)
                TextField("Monto (ej. 12.50)", text: $monto)
                    .keyboardType(.decimalPad)
                Picker("Categoría", selection: $categoria) {
                    Text("Alimentación").tag("Alimentación")
                    Text("Servicios").tag("Servicios")
                    Text("Suministros").tag("Suministros")
                    Text("Transporte").tag("Transporte")
                }
            }
            .navigationTitle("Nuevo Registro")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardarMovimiento() }
                }
            }
        }
    }
}
