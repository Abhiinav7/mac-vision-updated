class Channel {
  final String name;
  final String url;

  Channel(this.name, this.url);

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      json['name'] as String,
      json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
