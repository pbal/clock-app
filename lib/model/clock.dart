class Clock {
  String type;

  int seconds;
  int increment;
  int delay;

  Clock(this.type, this.seconds, this.increment, this.delay);

  static get presets {
    return [
      Clock('Ultra Bullet', 15, 0, 0),
      Clock('Hyper Bullet', 30, 0, 0),
      Clock('Bullet', 60, 0, 0),
      Clock('Bullet', 120, 0, 1),
      Clock('Blitz', 180, 0, 0),
      Clock('Blitz', 180, 0, 2),
      Clock('Blitz', 300, 0, 0),
      Clock('Blitz', 300, 0, 5),
      Clock('Rapid', 600, 0, 0),
      Clock('Rapid', 600, 0, 10),
      Clock('Classical', 900, 0, 0),
      Clock('Classical', 900, 0, 15),
    ];
  }
}
