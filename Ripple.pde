class Ripple {
  boolean hasRipple;
  int x, y;
  int tick;
  float d;
  final static int maxT = 20;

  Ripple() {
    hasRipple = false;
  }

  void activate(int x, int y) {
    this.x = x;
    this.y = y;

    tick = maxT;
    d = 5;
    hasRipple = true;
  }

  void draw() {
    if (!hasRipple) return;
    tick--;
    if (tick <= 0) {
      hasRipple = false;
      return;
    }

    noStroke();
    fill(128, 255, 255, alpha(tick));
    updateDiameter(tick);
    ellipse(x, y, d, d);
  }

  int alpha(int t) {
    return 192 * t / maxT;
  }

  void updateDiameter(int t) {
    d += (float)t * 0.6;
  }
}

