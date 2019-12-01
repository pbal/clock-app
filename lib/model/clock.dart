class Clock {
  String type;

  int seconds;
  int increment;
  int delay;

  Clock({this.type, this.seconds, this.increment, this.delay});

  static get presets {
    return [
      Clock(type: 'Ultra Bullet', seconds: 15, delay: 0, increment: 0),
      Clock(type: 'Hyper Bullet', seconds: 30, delay: 0, increment: 0),
      Clock(type: 'Bullet', seconds: 60, delay: 0, increment: 0),
      Clock(type: 'Bullet', seconds: 120, delay: 0, increment: 1),
      Clock(type: 'Blitz', seconds: 180, delay: 0, increment: 0),
      Clock(type: 'Blitz', seconds: 180, delay: 0, increment: 2),
      Clock(type: 'Blitz', seconds: 300, delay: 0, increment: 0),
      Clock(type: 'Blitz', seconds: 300, delay: 0, increment: 5),
      Clock(type: 'Rapid', seconds: 600, delay: 0, increment: 0),
      Clock(type: 'Rapid', seconds: 600, delay: 0, increment: 10),
      Clock(type: 'Classical', seconds: 900, delay: 0, increment: 0),
      Clock(type: 'Classical', seconds: 900, delay: 0, increment: 15),
    ];
  }
}
