import SwiftUI

// MARK: - Theme & Palette
struct Palette {
    // Dark base inspired by the logo backdrop
    let darkBase = Color(red: 0.10, green: 0.10, blue: 0.11) // near-black charcoal
    let darkElevated = Color(red: 0.14, green: 0.14, blue: 0.16)

    // Cyan -> Blue gradient inspired by the logo "D"
    let cyan = Color(red: 0.13, green: 0.93, blue: 0.86)     // bright cyan/teal edge
    let teal = Color(red: 0.00, green: 0.73, blue: 0.75)
    let blue = Color(red: 0.06, green: 0.45, blue: 0.86)
    let deepBlue = Color(red: 0.03, green: 0.25, blue: 0.53)

    // Accents for foreground
    let accentPrimary = Color(red: 0.00, green: 0.78, blue: 0.82) // teal
    let accentSecondary = Color(red: 0.06, green: 0.45, blue: 0.86) // blue
}

struct Theme {
    let palette = Palette()
}

// Shared app theme instance (can be moved to an Environment later)
let AppTheme = Theme()
