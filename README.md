# String Calculator – Flutter / Dart

A lightweight implementation of the classic **String Calculator kata** written in Dart for use in a Flutter project. This version intentionally takes a *regex-first* parsing approach: it simply scans the input for signed integer substrings (`-?\d+`) and processes them according to the rules below. Because of that design, many traditional "delimiter" complications melt away—the function is resilient to junk symbols, emojis, and even malformed custom‐delimiter headers.

---

## Quick Start

```bash
# Clone (replace with your repo URL)
git clone <YOUR-REPO-URL>.git
cd <project-directory>

# Fetch packages
flutter pub get

# Run the test suite
flutter test
```

---

## Public API

```dart
int add(String input)
```

**Parameters**

* `input` – Any string that may (or may not) contain integers mixed with arbitrary characters.

**Returns**

* The sum of all **non‑negative integers ≤ 1000** found in the string.

**Throws**

* `Exception` listing *all* negative integers discovered (even those with absolute value > 1000).

---

## Behavior Summary

| Case                           | Example Input              | Result | Notes                                                |
| ------------------------------ | -------------------------- | ------ | ---------------------------------------------------- |
| Empty string                   | `""`                       | `0`    | Base case.                                           |
| Single number                  | `"5"`                      | `5`    | Parsed directly.                                     |
| Multiple numbers               | `"1,2,3"`                  | `6`    | Any non‑digit char acts as a delimiter.              |
| Junk delimiters                | `"1,?2;3$$4"`              | `10`   | Symbols ignored.                                     |
| Emojis                         | `"🍎7🐍8"`                 | `15`   | Emojis treated as delimiters.                        |
| Newlines                       | `"1\n2,3"`                 | `6`    | `\n` or `\r\n` are just delimiters.                  |
| Custom header ignored          | `"//;\n1;?2"`              | `3`    | Header not parsed specially; digits in body counted. |
| Multi‑delimiter header ignored | `"//[;][%]\n1;2%3"`        | `6`    | Same.                                                |
| Negative triggers error        | `"1,-2,3"`                 | throws | Error message lists *all* negatives.                 |
| Negative >1000 still error     | `"2,-1005,3"`              | throws | Negatives never ignored.                             |
| >1000 ignored (positive)       | `"2,1001"`                 | `2`    | Values >1000 skipped in sum.                         |
| 1000 included                  | `"1000,1"`                 | `1001` | Boundary inclusive.                                  |
| No digits                      | `"@@@"`, `"abc"`, `"💥🔥"` | `0`    | Nothing to add.                                      |
| Leading zeros                  | `"0007"`                   | `7`    | Standard int parse.                                  |
| Embedded digits                | `"a12b3c004"`              | `19`   | All digit runs counted.                              |
| Digits in header counted       | `"//123\n4"`               | `127`  | Header digits treated like any digits.               |

---

## Detailed Rules

1. **Scan for signed integers** using regex: `-?\d+`.
2. **Collect all matches** in order of appearance.
3. **Classify each**:

   * If `< 0`: store in `negatives` list.
   * Else if `≤ 1000`: include in `numbers` list for summing.
   * Else (`> 1000` and non‑negative): ignore.
4. **Error on negatives**: If any negatives found, throw `Exception('Negative numbers not allowed: $negatives')`.
5. **Return sum** of `numbers` (or `0` if none).

This approach means *everything that is not part of a digit run becomes a delimiter automatically*—commas, semicolons, slashes, brackets, emojis, letters, whitespace, etc.

---

## Tests

An extensive test suite validates all of the behaviors above (plus stress testing). The file lives at:

```
test/string_calculator_test.dart
```

### Test Groups Covered

* **Core** – empty, single, multiple, junk delimiters, emoji delimiters.
* **Newlines & Mixed** – `\n`, Windows `\r\n`, noisy custom delimiter headers.
* **Negatives** – single, multiple, embedded in junk, large negatives.
* **>1000 Rule** – boundary at 1000, ignore 1001+, mixed values.
* **No Digits** – symbols / letters / emojis only.
* **Leading Zeros & Embedded** – numeric parsing robustness.
* **Header Digits Edge** – confirms digits in delimiter header count toward sum.
* **Idempotency** – repeated calls do not leak state.
* **Stress** – 1..500 sequence with alternating junk delimiters.

Run the tests:

```bash
flutter test
```

The stress test dynamically builds a 500‑number string, alternating `???` and `,,` as junk delimiters, and asserts the computed sum matches the arithmetic series total.

---

## Project Layout

```
.
├─ lib/
│  └─ string_calculator.dart      # add() implementation
├─ test/
│  └─ string_calculator_test.dart # Unit tests (provided in issue / snippet)
└─ pubspec.yaml                   # Flutter / Dart deps
```

---

## Extending the Kata

If you want to evolve this toward the "full" String Calculator kata behavior (where a leading header specifies custom delimiters), here are some ideas:

* Parse `//;\n` to treat `;` specifically (though current regex approach already works for most junk).
* Support multi‑char delimiters in brackets: `//[***]\n1***2***3`.
* Support multiple delimiters: `//[*][%]\n1*2%3`.
* Allow configurable **max include value** (currently 1000 hard‑coded).
* Emit a custom exception type (e.g., `NegativeNumberException`) for clearer error handling.
* Provide a helper that returns both the parsed list and the sum for debugging.

---

## Performance Notes

* Uses a single regex scan (`allMatches`) over the input string → linear in input length.
* Integer parsing is cheap for modestly sized digit runs; very long digit runs will still parse to `int` (Dart BigInt upgrade not needed here unless you expect >64‑bit values).
* The stress test (500 numbers) runs comfortably within typical unit test time budgets.

---

## Troubleshooting

**Tests failing due to negative numbers?** Ensure your input doesn't contain a `-` immediately before digits unless you intend to test error behavior.

**Unexpected large totals?** Remember numbers >1000 are ignored *unless negative* (then they cause an error).

**Header digits counted?** Yes—because headers are not parsed specially. For example, `"//123\n4"` sums to `127`.

---

## Contributing

PRs welcome! If you add enhanced delimiter parsing or additional kata stages, include new test groups that document the intended behavior.

---

### Acknowledgments

Inspired by the original [String Calculator kata](http://osherove.com/tdd-kata-1/) by Roy Osherove (concept); adapted for a resilient regex‑parsing demo in Flutter/Dart.

---

**Happy testing!**
