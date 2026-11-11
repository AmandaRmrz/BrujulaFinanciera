# 🧭 Brújula Financiera - Asistencia Contextual en iOS con TipKit

**Brújula Financiera** es una aplicación desarrollada en **SwiftUI** para la gestión y control presupuestario personal. Incorpora el framework **TipKit** de Apple para brindar asistencia contextual e interactiva en tiempo real (*Just-in-Time Learning*), orientando al usuario sin saturar la interfaz gráfica.

Proyecto desarrollado para la asignatura **ETPS4** (Normas y Estándares Internacionales) - Universidad Tecnológica de El Salvador.

---

## 🚀 Características Principales

* **Gestión de Ingresos y Gastos (CRUD):** Registro, visualización, filtrado dinámico por categorías y eliminación mediante gestos (*swipe-to-delete*).
* **Asistencia Contextual con TipKit:**
  * **Popover Tips (`.popoverTip`):** Guía visual interactiva para orientar al usuario sobre el botón de agregar registros (`+`).
  * **Inline TipViews (`TipView`):** Banners de advertencia reactivos que se activan automáticamente si el balance cae en saldo negativo.
* **Persistencia de Datos Local:** Modelos basados en el protocolo `Codable` serializados a JSON y almacenados con `@AppStorage` / `UserDefaults`.
* **Diseño Reactivo:** Dashboard dinámico con cálculo de balance en tiempo real y componentes visuales adaptativos.

---

## 🛠️ Tecnologías Utilizadas

* **Lenguaje:** Swift 5+
* **Frameworks UI:** SwiftUI
* **Framework Contextual:** TipKit
* **Persistencia:** `@AppStorage`, `UserDefaults`, `Codable`, `JSONEncoder`/`JSONDecoder`
* **Control de Versiones:** Git & GitHub

---

## 📱 Capturas de Pantalla

| Dashboard Inicial | Formulario Modal | Alerta TipKit (Saldo Negativo) |
| :---: | :---: | :---: |
| ![Dashboard](BrujulaFinanciera/img/Dashboard%20Inicial.png) | ![Formulario](BrujulaFinanciera/img/Formulario%20Modal.png) | ![Saldo Negativo](BrujulaFinanciera/img/Saldo%20Negativo.png) |

