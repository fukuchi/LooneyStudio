/**
 * LooneyStudio - a tiny stopmotion animation tool.
 *
 * Copyright (C) 2015 Kentaro Fukuchi <kentaro@fukuchi.org>
 *
 * This software is released under the revised BSD license. See LICENSE file
 * for the details.
 */

String projectFolder;

Sequence sequence;
SequenceViewer sequenceViewer;
CameraFrame cameraFrame;
ControlPanel controlPanel;
Ripple ripple;
boolean setupFinished = false;

void setup() {
  size(1024, 768);
  selectFolder("Select a project folder:", "folderSelected");
  frameRate(30);
  background(192);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Initializing...", width / 2, height / 2);
  textAlign(LEFT, TOP);
  noLoop();
}

void setup_real() {
  cameraFrame = new CameraFrame();
  cameraFrame.openCamera(this);
  sequence = new Sequence(90, projectFolder, cameraFrame);
  sequence.loadImages();
  sequenceViewer = new SequenceViewer(sequence);
  sequence.setViewer(sequenceViewer);
  controlPanel = new ControlPanel();
  ripple = new Ripple();

  setupFinished = true;
  background(192);
  loop();
}

void draw() {
  PImage img;

  if (!setupFinished) return;

  background(192);
  if (controlPanel.playing) {
    img = sequence.getCurrentPlayingFrame();
    cameraFrame.drawAnimation(img);
    sequence.stepPlay();
  } else {
    cameraFrame.draw();
  }
  sequenceViewer.draw();
  controlPanel.draw();
  ripple.draw();
  sequenceViewer.transporterDraw();
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Please restart this program to select an appropriate project folder.");
    return;
  }

  projectFolder = selection.getAbsolutePath();
  setup_real();
}

void mouseClicked() {
  boolean ret;
  ret = controlPanel.mouseClicked();
  ret |= sequenceViewer.mouseClicked();
  if (ret) ripple.activate(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' ') {
    sequence.shoot();
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      if (sequenceViewer.frameShifting) {
        sequenceViewer.shiftLeft();
      }
    } else if (keyCode == RIGHT) {
      if (sequenceViewer.frameShifting) {
        sequenceViewer.shiftRight();
      }
    }
  }
}
