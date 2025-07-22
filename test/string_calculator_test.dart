int add(String input) {

  if (input.isEmpty) return 0;

  // Detect custom delimiters
  final delimiterRegex = RegExp(r'^//(\[.*?\]|.)+\n');
  List<String> delimiters = [',', '\n', ';'];

  String numbersSection = input;

  if (delimiterRegex.hasMatch(input)) {
    final delimiterPart = delimiterRegex.firstMatch(input)!.group(0)!;
    numbersSection = input.substring(delimiterPart.length);

    // Extract custom delimiters
    final customDelimiters = RegExp(r'\[(.*?)\]').allMatches(delimiterPart);
    if (customDelimiters.isNotEmpty) {
      delimiters = customDelimiters.map((m) => RegExp.escape(m.group(1)!)).toList();
    } else {
      delimiters = [RegExp.escape(delimiterPart.substring(2, delimiterPart.length - 1))];
    }
  }

  // Split by delimiters
  final delimiterPattern = RegExp(delimiters.join('|'));
  final parts = numbersSection.split(delimiterPattern);

  // Convert to integers
  final numbers = parts
      .where((p) => p.trim().isNotEmpty)
      .map(int.parse)
      .where((n) => n <= 1000)
      .toList();

  // Check for negatives
  final negatives = numbers.where((n) => n < 0).toList();
  if (negatives.isNotEmpty) {
    throw Exception('Negative numbers not allowed: $negatives');
  }

  return numbers.fold(0, (sum, n) => sum + n);
}
