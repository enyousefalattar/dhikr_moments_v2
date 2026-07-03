class AzkarItem {
  final String id;
  final String category;
  final String text;
  final String? description;
  final int? count;
  final String? reference;

  const AzkarItem({
    required this.id,
    required this.category,
    required this.text,
    this.description,
    this.count,
    this.reference,
  });

  factory AzkarItem.fromRow(List<dynamic> row) {
    final category = row[0] as String;
    final text = row[1] as String;
    return AzkarItem(
      id: "${category}_${text.hashCode}",
      category: category,
      text: text,
      description: row[2] as String?,
      count: row[3] is int ? row[3] as int : int.tryParse(row[3].toString()),
      reference: row[4] as String?,
    );
  }
}
