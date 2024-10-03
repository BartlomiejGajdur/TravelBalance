class Statistics {
  int totalTripsAmount;
  int visitedCountriesAmount;
  double spendings;

  Statistics({
    required this.totalTripsAmount,
    required this.visitedCountriesAmount,
    required this.spendings,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalTripsAmount: json['totalTripsAmount'] ?? 0,
      visitedCountriesAmount: json['visitedCountriesAmount'] ?? 0,
      spendings: (json['spendings'] ?? 0).toDouble(),
    );
  }
}
