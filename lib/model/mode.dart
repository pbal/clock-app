class ClockMode {
  static List<double> get time {
    return [0, 0.5, 0.75, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 45, 60, 90, 120];
  }

  static List<int> get timeSeconds {
    return time.map((t) => (t * 60).toInt()).toList();
  }

  static List<int> get increment {
    return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 25, 30, 45, 60, 90, 120, 150, 180];
  }

  static get modes {
    return [
      'Sudden Death',
      'Increment',
      'Simple Delay',
      'Bronstein Delay'
    ];
  }
}
