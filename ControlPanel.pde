class ControlPanel {
  PImage panel;
  boolean seamlessLoop;
  boolean showPrevFrame;
  boolean playing;
  boolean locked;

  final static int _PLAY = 0;
  final static int _STOP = 1;
  final static int _LOOP = 2;
  final static int _SHOOT = 3;
  final static int _SHOWPREV = 4;
  final static int _TRASH = 5;
  final static int _PROTECT = 6;
  final static int _ICONLAST = 7;

  ControlPanel() {
    panel = loadImage("controlpanel.png");
    seamlessLoop = true;
    showPrevFrame = true;
  }

  void draw() {
    pushMatrix();
    translate(8, 8);
    stroke(0);
    fill(255);
    image(panel, 0, 0);

    fill(128, 192);
    if (locked) {
      for (int i = 0; i<_ICONLAST; i++) {
        maskIcon(i);
      }
    }
    if (!seamlessLoop) {
      maskIcon(_LOOP);
    }
    if (!showPrevFrame) {
      maskIcon(_SHOWPREV);
    }
    if (playing) {
      maskIcon(_SHOOT);
      maskIcon(_SHOWPREV);
      maskIcon(_TRASH);
      maskIcon(_PROTECT);
    }

    popMatrix();
  }

  void maskIcon(int num) {
    int x = num % 3;
    int y = num / 3;
    int ox = 7 + x * 78;
    int oy = 135 + y * 78;
    rect(ox + 2, oy + 2, 66, 66);
  }

  boolean mouseClicked() {
    if (locked) return false;

    int x = mouseX - 15;
    int y = mouseY - 143;
    int cx = x / 78;
    int cy = y / 78;
    int dx = x - cx * 78;
    int dy = y - cy * 78;
    if (cx < 0 || cx > 2 || cy < 0 || cy > 2) return false;
    if (dx < 0 || dx >= 68 || dy < 0 || dy >= 68) return false;

    int num = cy * 3 + cx;
    if (num >= _ICONLAST) return false;

    switch(num) {
    default:
    case _PLAY:
      playing = true;
      sequence.startPlay();
      break;
    case _STOP:
      playing = false;
      sequence.stopPlay();
      break;
    case _LOOP:
      seamlessLoop ^= true;
      break;
    case _SHOOT:
      if (!playing) {
        sequence.shoot();
      }
      break;
    case _SHOWPREV:
      if (!playing) {
        showPrevFrame ^= true;
      }
      break;
    case _TRASH:
      if (!playing) {
        sequence.trash();
      }
      break;
    case _PROTECT:
      if (!playing) {
        sequence.toggleProtection();
      }
      break;
    }

    return true;
  }

  void forceStop() {
    playing = false;
    sequence.stopPlay();
  }

  void lockPanel() {
    locked = true;
  }

  void unlockPanel() {
    locked = false;
  }
}

