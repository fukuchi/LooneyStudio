class SequenceViewer {
  Sequence sequence;
  PImage cameraIcon, shiftIcon;
  boolean transporting;
  boolean frameShifting;
  int transport_x1, transport_x2, transport_y1, transport_y2;
  int transport_tick;
  final static int transport_maxT = 10;
  int frameShiftBase;

  SequenceViewer(Sequence seq) {
    sequence = seq;
    cameraIcon = loadImage("cameraicon.png");
    shiftIcon = loadImage("shifticon.png");
    transporting = false;
    frameShifting = false;
  }

  void draw() {
    int ox, oy;

    pushMatrix();
    translate(0, 388);
    stroke(0);
    fill(255);
    rect(0, 0, width-1, 375);

    int i = 0;

    noStroke();
    textSize(10);
    for (int y=0; y<6; y++) {
      oy = thumbnailPosY(y);
      for (int x=0; x<15; x++) {
        ox = thumbnailPosX(x);
        drawThumbFrame(i, ox, oy);
        if (sequence.frames[i] != null) {
          image(sequence.frames[i].thumbnail, ox, oy);
        }
        i++;
      }
    }

    if (frameShifting) {
      ox = frameShiftBase % 15;
      oy = frameShiftBase / 15;
      ox = thumbnailPosX(ox);
      oy = thumbnailPosY(oy);
      image(shiftIcon, ox + 20, oy + 15);
    } else {
      ox = sequence.currentCameraPosition % 15;
      oy = sequence.currentCameraPosition / 15;
      ox = thumbnailPosX(ox);
      oy = thumbnailPosY(oy);
      image(cameraIcon, ox, oy);
    }

    popMatrix();
  }

  int thumbnailPosX(int x) {
    return x * 66 + 17;
  }

  int thumbnailPosY(int y) {
    return y * 60 + 12;
  }

  void drawThumbFrame(int n, int ox, int oy) {
    boolean large = false;
    if (sequence.isFrameProtected(n)) {
      fill(255, 0, 0);
      large = true;
    } else if (n == sequence.currentCameraPosition) {
      fill(0, 255, 0);
      large = true;
    } else if (n == sequence.currentPlayerPosition) {
      fill(0, 128, 255);
      large = true;
    } else {
      fill(0);
    }
    if (large) {
      rect(ox - 2, oy - 2, 64, 49);
    } else {
      rect(ox - 1, oy - 1, 62, 47);
    }

    fill(192);
    rect(ox, oy, 60, 45);

    fill(128);
    String nstr = String.format("%2d", n);
    text(nstr, ox, oy + 45);
  }

  boolean mouseClicked() {
    int x = mouseX - 17;
    int y = mouseY - 384 - 12;
    int cx = x / 66;
    int cy = y / 60;
    if (cx < 0 || cx > 14 || cy < 0 || cy > 5) return false;
    int dx = x - cx * 66;
    int dy = y - cy * 60;
    if (dx < 0 || dx > 60 || dy < 0 || dy > 45) return false;

    int number = cy * 15 + cx;

    if (mouseButton == LEFT) {
      if (frameShifting) {
        if (number != frameShiftBase|| dx < 20 || dx > 40 || dy < 15 || dy > 30) {
          endFrameShift();
          return true;
        }
        if (dx < 30) {
          shiftLeft();
        } else {
          shiftRight();
        }
      } else {
        sequence.setCameraPosition(number);
      }
    } else if (mouseButton == RIGHT) {
      if (frameShifting) {
        endFrameShift();
      } else {
        if (sequence.frames[number] != null) {
          startFrameShift(number);
        }
      }
    }

    return true;
  }

  void setTransportation(int position) {
    int cx = position % 15;
    int cy = position / 15;
    transporting = true;
    transport_x1 = 256;
    transport_y1 = 2;
    transport_x2 = thumbnailPosX(cx);
    transport_y2 = thumbnailPosY(cy) + 388;
    transport_tick = 0;
  }

  void transporterDraw() {
    if (!transporting) return;

    float t = 1.0 - (float) transport_tick / transport_maxT;
    float r = 1.0 - t * t * t;

    int x = (int)(transport_x1 + r * (transport_x2 - transport_x1));
    int y = (int)(transport_y1 + r * (transport_y2 - transport_y1));
    int w = (int)(512 - r * (512 - 60));
    int h = (int)(384 - r * (384 - 45));
    stroke(255);
    noFill();
    rect(x, y, w, h);

    transport_tick++;
    if (transport_tick >= transport_maxT) {
      transporting = false;
    }
  }

  void startFrameShift(int number) {
    frameShifting = true;
    frameShiftBase = number;
    controlPanel.lockPanel();
  }

  void endFrameShift() {
    frameShifting = false;
    controlPanel.unlockPanel();
  }

  void shiftLeft() {
    boolean ret = sequence.shiftLeft(frameShiftBase);
    if (ret) frameShiftBase--;
  }

  void shiftRight() {
    boolean ret = sequence.shiftRight(frameShiftBase);
    if (ret) frameShiftBase++;
  }

  void shiftCameraPosition(int d) {
    sequence.shiftCameraPosition(d);
  }
}

