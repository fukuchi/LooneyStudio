import processing.video.*;

class CameraFrame {
  Capture camera;
  PImage current, prev;

  CameraFrame() {
    prev = null;
  }

  void openCamera(PApplet applet) {
    camera = new Capture(applet, 640, 480);
    if (camera == null) {
      println("Failed to open camear (probably no camer device attached.)");
      return;
    }

    camera.start();
  }

  PImage getLatestFrame() {
    if (camera.available()) {
      camera.read();
      current = camera.get();
    }
    return current;
  }

  void drawAnimation(PImage img) {
    pushMatrix();
    translate(256, 2);
    image(img, 0, 0, 512, 384);
    popMatrix();
  }

  void draw() {
    pushMatrix();
    translate(256, 2);

    PImage latest = getLatestFrame();
    if (latest == null || controlPanel.locked) {
      stroke(0);
      fill(192);
      rect(0, 0, 512, 384);
    } else if (prev != null && controlPanel.showPrevFrame) {
      image(prev, 0, 0, 512, 384);
      tint(255, 192);
      image(latest, 0, 0, 512, 384);
      noTint();
    } else {
      image(latest, 0, 0, 512, 384);
    }
    popMatrix();
  }

  PImage shoot() {
    return current;
  }

  void setPrev(PImage img) {
    prev = img;
  }
}

