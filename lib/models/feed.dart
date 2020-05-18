class Challenge {
  String name;
  String description;
  String rarity;

  Challenge(this.name, this.description, this.rarity);

  static List<Challenge> generateChallenge() {
    var list = [
      Challenge("Challenge #1", "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.", "simple"),
      Challenge("Challenge #2", "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.", "simple"),
      Challenge("Challenge #3", "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.", "hard"),
      Challenge("Challenge #4", "Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.", "legendary"),
    ];
    list.shuffle();
    return list;
  }
}
