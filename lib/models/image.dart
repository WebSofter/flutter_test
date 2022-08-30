class ImageModel {
  late int albumId;
  late int id;
  late String title;
  late String url;

  ImageModel(this.albumId, this.id, this.url, this.title);

  ImageModel.fromJson(Map<String, dynamic> parsedJson) {
    this
      ..albumId = parsedJson['albumId']
      ..id = parsedJson['id']
      ..url = parsedJson['url']
      ..title = parsedJson['title'];
  }

  String toString() => 'Image id: $id, title: $title, url: $url';
}
