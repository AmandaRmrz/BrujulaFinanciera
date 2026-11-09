//
//  ContentView.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import SwiftUI
import TipKit

struct ContentView: View {
    //Persistencia
    @AppStorage("movimientos_data") private var movimientosData: Data = Data()
    @AppStorage("categorias_data") private var categoriasData: Data = Data()
    
    @State private var movimientos: [MovimientoFinanciero] = []
    @State private var categorias: [CategoriaFinanciera] = CategoriaFinanciera.predeterminadas
    
    //Tips
    private let consejoAgregar = ConsejoAgregarMovimientoTip()
    private let alertaDesviacion = AlertaDesviacionTip()
    private let filtradoTip = FiltradoCategoriaTip()
    
    //Estados de UI
    @State private var mostrarModalRegistro = false
    @State private var mostrarModalCategorias = false
    @State private var categoriaSeleccionada: String = "Todas"
    
    //Campos de Formulario
    @State private var concepto = ""
    @State private var monto = ""
    @State private var categoriaNombre = "Alimentación"
    @State private var tipoSeleccionado: TipoMovimiento = .gasto
    @State private var nuevaCategoriaNombre = ""
    
    //Propiedades Calculadas
    var totalIngresos: Double {
        movimientos.filter { $0.tipo == .ingreso }.reduce(0) { $0 + $1.monto }
    }
    
    var totalGastos: Double {
        movimientos.filter { $0.tipo == .gasto }.reduce(0) { $0 + $1.monto }
    }
    
    var balanceTotal: Double {
        totalIngresos - totalGastos
    }
    
    var movimientosFiltrados: [MovimientoFinanciero] {
        if categoriaSeleccionada == "Todas" {
            return movimientos
        } else {
            return movimientos.filter { $0.categoria == categoriaSeleccionada }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                //Banner de TipKit (Inline)
                TipView(alertaDesviacion) { action in
                    if action.id == "entendido" {
                        AlertaDesviacionTip.alertaGastosElevados = false
                    }
                }
                .padding(.horizontal)

                //1. Dashboard Financiero (Tarjeta Resumen)
                tarjetaDashboard
                    .padding(.horizontal)

                //2. Filtros de Categoria Horizontales
                barraFiltrosCategorias
                    .popoverTip(filtradoTip)

                //3. Lista de Registros
                List {
                    Section(header: Text("Movimientos Registrados")) {
                        if movimientosFiltrados.isEmpty {
                            ContentUnavailableView(
                                "Sin Transacciones",
                                systemImage: "compass.drawing",
                                description: Text("No hay registros en esta categoría.")
                            )
                        } else {
                            ForEach(movimientosFiltrados) { item in
                                filaMovimiento(item)
                            }
                            .onDelete(perform: eliminarMovimiento)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Brújula Financiera")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { mostrarModalRegistro = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .popoverTip(consejoAgregar, arrowEdge: .top)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button(action: { mostrarModalCategorias = true }) {
                            Label("Gestionar Categorías", systemImage: "folder.badge.gearshape")
                        }
                        Button(role: .destructive, action: resetTips) {
                            Label("Reiniciar TipKit", systemImage: "arrow.counterclockwise")
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $mostrarModalRegistro) { formularioAgregar }
            .sheet(isPresented: $mostrarModalCategorias) { modalGestionCategorias }
            .onAppear(perform: cargarTodo)
        }
    }

    //Componentes de Interfaz Grafica

    private var tarjetaDashboard: some View {
        VStack(spacing: 14) {
            Text("Balance Disponible")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Text("$\(balanceTotal, specifier: "%.2f")")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            HStack {
                HStack {
                    Image(systemName: "arrow.down.circle.fill").foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Ingresos").font(.caption).foregroundColor(.white.opacity(0.7))
                        Text("+$ \(totalIngresos, specifier: "%.2f")").font(.footnote).bold().foregroundColor(.white)
                    }
                }
                Spacer()
                HStack {
                    Image(systemName: "arrow.up.circle.fill").foregroundColor(.red)
                    VStack(alignment: .leading) {
                        Text("Gastos").font(.caption).foregroundColor(.white.opacity(0.7))
                        Text("-$ \(totalGastos, specifier: "%.2f")").font(.footnote).bold().foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.9), Color.indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(18)
        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    private var barraFiltrosCategorias: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button(action: { categoriaSeleccionada = "Todas" }) {
                    Text("Todas")
                        .font(.caption).bold()
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(categoriaSeleccionada == "Todas" ? Color.blue : Color(.systemGray5))
                        .foregroundColor(categoriaSeleccionada == "Todas" ? .white : .primary)
                        .clipShape(Capsule())
                }
                
                ForEach(categorias) { cat in
                    Button(action: { categoriaSeleccionada = cat.nombre }) {
                        HStack(spacing: 4) {
                            Image(systemName: cat.icono)
                            Text(cat.nombre)
                        }
                        .font(.caption).bold()
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(categoriaSeleccionada == cat.nombre ? Color.blue : Color(.systemGray5))
                        .foregroundColor(categoriaSeleccionada == cat.nombre ? .white : .primary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func filaMovimiento(_ item: MovimientoFinanciero) -> some View {
        HStack {
            Image(systemName: buscarIcono(para: item.categoria))
                .font(.title3)
                .foregroundColor(item.tipo.color)
                .frame(width: 36, height: 36)
                .background(item.tipo.color.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(item.concepto).font(.headline)
                Text(item.categoria).font(.caption).foregroundColor(.secondary)
            }

            Spacer()

            Text("\(item.tipo == .ingreso ? "+" : "-") $\(item.monto, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(item.tipo.color)
        }
    }

    //Modales

    private var formularioAgregar: some View {
        NavigationStack {
            Form {
                Section("Tipo de Movimiento") {
                    Picker("Tipo", selection: $tipoSeleccionado) {
                        ForEach(TipoMovimiento.allCases) { tipo in
                            Text(tipo.rawValue).tag(tipo)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Detalles") {
                    TextField("Concepto (Ej. Supermercado)", text: $concepto)
                    TextField("Monto ($)", text: $monto)
                        .keyboardType(.decimalPad)
                    
                    Picker("Categoría", selection: $categoriaNombre) {
                        ForEach(categorias) { cat in
                            Text(cat.nombre).tag(cat.nombre)
                        }
                    }
                }
            }
            .navigationTitle("Nuevo Registro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { mostrarModalRegistro = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardarMovimiento() }
                }
            }
        }
    }

    private var modalGestionCategorias: some View {
        NavigationStack {
            List {
                Section("Agregar Nueva Categoría") {
                    HStack {
                        TextField("Nombre categoría", text: $nuevaCategoriaNombre)
                        Button("Agregar") {
                            guard !nuevaCategoriaNombre.isEmpty else { return }
                            let nueva = CategoriaFinanciera(nombre: nuevaCategoriaNombre, icono: "tag.fill")
                            categorias.append(nueva)
                            nuevaCategoriaNombre = ""
                            persistirCategorias()
                        }
                        .disabled(nuevaCategoriaNombre.isEmpty)
                    }
                }

                Section("Categorías Existentes") {
                    ForEach(categorias) { cat in
                        HStack {
                            Image(systemName: cat.icono).foregroundColor(.blue)
                            Text(cat.nombre)
                            if cat.esPredeterminada {
                                Spacer()
                                Text("Predeterminada").font(.caption2).foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: eliminarCategoria)
                }
            }
            .navigationTitle("Administrar Categorías")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { mostrarModalCategorias = false }
                }
            }
        }
    }

    //Logica de Negocio

    private func guardarMovimiento() {
        guard let montoDouble = Double(monto), !concepto.isEmpty else { return }
        let nuevo = MovimientoFinanciero(concepto: concepto, monto: montoDouble, categoria: categoriaNombre, tipo: tipoSeleccionado)
        movimientos.append(nuevo)
        persistirTodo()

        Task {
            await TipEvents.registroCreado.donate()
        }

        // Evaluar TipKit Rule basada en parámetro
        if totalGastos > totalIngresos && totalIngresos > 0 {
            AlertaDesviacionTip.alertaGastosElevados = true
        }

        concepto = ""
        monto = ""
        mostrarModalRegistro = false
    }

    private func eliminarMovimiento(offsets: IndexSet) {
        movimientos.remove(atOffsets: offsets)
        persistirTodo()
    }

    private func eliminarCategoria(offsets: IndexSet) {
        categorias.remove(atOffsets: offsets)
        persistirCategorias()
    }

    private func buscarIcono(para categoria: String) -> String {
        categorias.first(where: { $0.nombre == categoria })?.icono ?? "dollarsign.circle.fill"
    }

    private func persistirTodo() {
        if let encoded = try? JSONEncoder().encode(movimientos) { movimientosData = encoded }
        persistirCategorias()
    }

    private func persistirCategorias() {
        if let encoded = try? JSONEncoder().encode(categorias) { categoriasData = encoded }
    }

    private func cargarTodo() {
        if let decoded = try? JSONDecoder().decode([MovimientoFinanciero].self, from: movimientosData) {
            movimientos = decoded
        }
        if let decoded = try? JSONDecoder().decode([CategoriaFinanciera].self, from: categoriasData) {
            categorias = decoded
        }
    }

    private func resetTips() {
        try? Tips.resetDatastore()
        AlertaDesviacionTip.alertaGastosElevados = false
    }
}
