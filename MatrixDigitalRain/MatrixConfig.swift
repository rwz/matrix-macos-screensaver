import Foundation

/// Central configuration for the Matrix Digital Rain screensaver.
/// All tunable constants live here for easy adjustment.
///
/// Uses a caseless `enum` instead of a `struct` to prevent accidental
/// instantiation — this is a pure namespace for static constants.
enum MatrixConfig {

    // MARK: - Rain rendering

    static let fontSize: CGFloat = 20
    static let columnWidth: CGFloat = 24
    static let fps: Double = 30

    /// Probability that any single character mutates on a given frame,
    /// creating the "glitch" effect. Applied independently to each cell.
    static let perCellMutationChance: Double = 0.02

    /// Brightness threshold at which a character is rendered as white (the "head").
    /// Slightly below 1.0 to account for floating-point imprecision in trail calculations.
    static let headBrightnessThreshold: Double = 0.95

    /// Extra rows beyond the visible area, so trails starting above the
    /// screen have character data ready before they scroll into view.
    static let offScreenRowBuffer: Int = 5

    // MARK: - Column behavior

    static let minTrailLength: Int = 10
    static let maxTrailLength: Int = 31
    static let minSpeed: Double = 0.05
    static let maxSpeed: Double = 0.50

    /// Maximum random delay (in seconds) before a column starts falling.
    /// Creates the staggered "wave" effect when the rain begins.
    static let maxColumnStaggerDelay: Double = 3.0

    // MARK: - CRT monitor effects

    /// Spacing in points between CRT scanlines.
    static let crtScanlineSpacing: CGFloat = 3

    /// Opacity of CRT scanlines (0 = invisible, 1 = fully opaque).
    static let crtScanlineAlpha: CGFloat = 0.12

    /// Blur radius for the green phosphor glow around rain characters.
    static let crtRainGlowRadius: CGFloat = 18

    /// Trail characters dimmer than this are hidden, so trails
    /// fade cleanly into darkness instead of showing dark remnants.
    static let trailBrightnessCutoff: Double = 0.15

    // MARK: - Character set

    /// All 57 printable glyphs from the Matrix-Code.ttf custom font.
    /// Includes mirrored katakana, digits, and symbols from the films.
    static let matrixChars: [Character] = Array(
        "モエヤキオカ7ケサスz152ヨタワ4ネヌナ98ヒ0ホア3ウセ¦:\"꞊ミラリ╌ツテニハソ▪コシマムメー©*+<>|\u{E937}"
    )

    /// Returns a random character from the Matrix character set.
    /// - Precondition: `matrixChars` must not be empty.
    static func randomChar() -> Character {
        guard let char = matrixChars.randomElement() else {
            fatalError("matrixChars is empty — the character set must contain at least one glyph")
        }
        return char
    }
}
