class Movie {
  final int id;
  final String title;
  final String country;
  final String year;
  final String overview;
  final String imageUrl;
  final double rate;
  final int rateCount;
  bool isAddedToWatch;
  bool isWatched;

  static final columns = [
    "id",
    "title",
    "country",
    "year",
    "overview",
    "imageUrl",
    "rate",
    "rateCount",
  ];

  set setAddedToWatch(bool isAdded) {
    isAddedToWatch = isAdded;
  }

  set setIsWatched(bool isAdded) {
    isWatched = isAdded;
  }

  Movie({
    this.id,
    this.title,
    this.country,
    this.year,
    this.overview,
    this.imageUrl,
    this.rate,
    this.rateCount,
    this.isAddedToWatch,
    this.isWatched,
  });

  factory Movie.fromMap(Map<String, dynamic> data) {
    return Movie(
      id: data['id'],
      title: data['title'],
      country: data['country'],
      year: data['year'],
      overview: data['overview'],
      imageUrl: data['imageUrl'],
      rate: data['rate'],
      rateCount: data['rateCount'],
    );
  }
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "country": country,
    "year": year,
    "overview": overview,
    "imageUrl": imageUrl,
    "rate": rate,
    "rateCount": rateCount,
  };
}
