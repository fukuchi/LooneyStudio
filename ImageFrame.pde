class ImageFrame {
  int number;
  String filename, path;
  PImage image;
  PImage thumbnail;
  boolean isProtected;

  ImageFrame(int number, String path) {
    this.number = number;
    this.path = path;
    this.isProtected = false;
  }

  void setImage(PImage img) {
    image = img;
    thumbnail = img.get();
    thumbnail.resize(60, 45);
    saveImage();
  }

  void loadSavedImage() {
    PImage img = loadImage(getFilename());
    setImage(img);
  }

  void saveImage() {
    image.save(getFilename());
  }

  void renumber(int number) {
    String oldfile = getFilename();
    this.number = number;
    saveImage();
    File file = new File(oldfile);
    file.delete();
  }

  void smartRenumber(int number) {
    File oldfile = new File(getFilename());
    this.number = number;
    File newfile = new File(getFilename());
    oldfile.renameTo(newfile);
  }

  String getFilename() {
    String base = path + "/" + String.format("%02d", number);
    if (isProtected) {
      base += "+";
    }
    return base + ".jpg";
  }

  void removeFile() {
    File file = new File(getFilename());
    if (file != null) {
      file.delete();
    }
  }

  void toggleProtection() {
    File oldfile = new File(getFilename());
    isProtected ^= true;
    File newfile = new File(getFilename());
    oldfile.renameTo(newfile);
  }
}

