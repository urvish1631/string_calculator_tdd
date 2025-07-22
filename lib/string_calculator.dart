int add(String input) {

  if (input.isEmpty) return 0;


  // Regex to find all integers
  final matches = RegExp(r'-?\d+').allMatches(input);

  // If no integer present in the input, return 0
  // This handles the case where the input is just a custom delimiter
  // like "//[;]\n" or "//[***]\n"
  if (matches.isEmpty) return 0;

  final numbers = <int>[];
  final negatives = <int>[];

  for (final match in matches) {
    final value = int.parse(match.group(0)!);

    if (value < 0) {
      negatives.add(value);
    } else if (value <= 1000) {
      numbers.add(value);
    }
    // Ignore values > 1000
  }

  // If there are any negative numbers, throw an exception with their values
  if (negatives.isNotEmpty) {
    throw Exception('Negative numbers not allowed: $negatives');
  }

  return numbers.fold(0, (sum, n) => sum + n);
}
