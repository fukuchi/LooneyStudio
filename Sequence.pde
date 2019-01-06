class Sequence {
  ImageFrame[] frames;
  String path;
  int maxFrames;
  int currentCameraPosition;
  int currentPlayerPosition;
  CameraFrame camera;
  SequenceViewer viewer;
  int lastNonNullFrame;
  int interval = 0;

  Sequence(int maxFrames, String path, CameraFrame camera) {
    this.maxFrames = maxFrames;
    this.path = path;
    this.frames = new ImageFrame[maxFrames];
    this.camera = camera;

    currentCameraPosition = 0;
    currentPlayerPosition = 0;
  }

  void setViewer(SequenceViewer viewer) {
    this.viewer = viewer;
  }

  void loadImages() {
    File dir = new File(path);
    String[] files = sort(dir.list());
    if (files == null) return;

    for (String filename : files) {
      String[] matches = match(filename, "([0-9][0-9])(\\+?)\\.jpg");
      if (matches != null) {
        int number = int(matches[1]);
        if (number >= 0 && number < maxFrames) {
          setNewImageFrame(number);
          if (matches[2].equals("+")) {
            frames[number].isProtected = true;
          }
          frames[number].loadSavedImage();
        }
      }
    }
  }

  void startPlay() {
    println("mogemoge");
    for (int i=0; i<maxFrames; i++) {
      int j = (i + currentPlayerPosition) % maxFrames;
      if (frames[j] != null) {
        currentPlayerPosition = j;
        break;
      }
    }
    lastNonNullFrame = -1;
    for (int i=0; i<maxFrames; i++) {
      if (frames[i] != null) {
        lastNonNullFrame = i;
      }
    }

    if (lastNonNullFrame < 0) {
      controlPanel.forceStop();
    }

    interval = 5;
  }

  void stopPlay() {
  }

  PImage getCurrentPlayingFrame() {
    return frames[currentPlayerPosition].image;
  }

  void stepPlay() {
    interval--;
    if (interval >= 0) return;

    interval = 5;
    if (currentPlayerPosition == lastNonNullFrame) {
      if (controlPanel.seamlessLoop) {
        currentPlayerPosition = -1;
      } else {
        return;
      }
    }
    while (currentPlayerPosition <= lastNonNullFrame) {
      currentPlayerPosition++;
      if (frames[currentPlayerPosition] != null) break;
    }
  }

  void shoot() {
    if (frames[currentCameraPosition] != null) {
      if (frames[currentCameraPosition].isProtected) {
        return;
      }
    }
    PImage img = camera.shoot();
    viewer.setTransportation(currentCameraPosition);
    if (frames[currentCameraPosition] == null) {
      setNewImageFrame(currentCameraPosition);
    }
    frames[currentCameraPosition].setImage(img);
    setCameraPosition(currentCameraPosition + 1);
  }

  void trash() {
    if (frames[currentCameraPosition] == null)  return;
    if (frames[currentCameraPosition].isProtected) return;
    frames[currentCameraPosition].removeFile();
    frames[currentCameraPosition] = null;
  }

  void toggleProtection() {
    if (frames[currentCameraPosition] == null)  return;
    frames[currentCameraPosition].toggleProtection();
  }

  boolean isFrameProtected(int num) {
    if (frames[num] == null) return false;
    return frames[num].isProtected;
  }

  void setCameraPosition(int number) {
    if (number >= maxFrames) {
      number = maxFrames - 1;
    }

    int prev = number - 1;
    if (prev < 0 || frames[prev] == null) {
      camera.setPrev(null);
    } else {
      camera.setPrev(frames[prev].image);
    }

    currentCameraPosition = number;
  }

  void shiftCameraPosition(int d) {
    int number = currentCameraPosition + d;
    if (number < 0) number = 0;
    if (number >= maxFrames) number = maxFrames - 1;

    setCameraPosition(number);
  }

  void setNewImageFrame(int number) {
    frames[number] = new ImageFrame(number, path);
  }

  boolean shiftLeft(int index) {
    int i = index;
    while (i >= 0) {
      if (frames[i] == null) break;
      i--;
    }
    if (i < 0) return false;

    while (i < index) {
      frames[i] = frames[i + 1];
      frames[i].smartRenumber(i);
      i++;
    }

    frames[index] = null;

    return true;
  }

  boolean shiftRight(int index) {
    int i = index;
    while (i < maxFrames) {
      if (frames[i] == null) break;
      i++;
    }
    if (i > maxFrames - 1) return false;

    while (i > index) {
      frames[i] = frames[i - 1];
      frames[i].smartRenumber(i);
      i--;
    }

    frames[index] = null;

    return true;
  }
}
