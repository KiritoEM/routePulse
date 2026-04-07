class SliderModel {
  String backgroundPath;
  String title;
  String description;

  SliderModel({
    required this.title,
    required this.description,
    required this.backgroundPath,
  });

  void setIllustration(String backgroundPath) {
    this.backgroundPath = backgroundPath;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }
}
