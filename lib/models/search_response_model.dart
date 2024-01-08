class SearchResult {
  String kind;
  String etag;
  SearchResultId id;
  SearchResultSnippet snippet;

  SearchResult({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      id: SearchResultId.fromJson(json['id'] ?? {}),
      snippet: SearchResultSnippet.fromJson(json['snippet'] ?? {}),
    );
  }
}

class SearchResultId {
  String kind;
  String videoId;
  String channelId;
  String playlistId;

  SearchResultId({
    required this.kind,
    required this.videoId,
    required this.channelId,
    required this.playlistId,
  });

  factory SearchResultId.fromJson(Map<String, dynamic> json) {
    return SearchResultId(
      kind: json['kind'] ?? '',
      videoId: json['videoId'] ?? '',
      channelId: json['channelId'] ?? '',
      playlistId: json['playlistId'] ?? '',
    );
  }
}

class SearchResultSnippet {
  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  Thumbnails thumbnails;
  String channelTitle;
  String liveBroadcastContent;

  SearchResultSnippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.liveBroadcastContent,
  });

  factory SearchResultSnippet.fromJson(Map<String, dynamic> json) {
    return SearchResultSnippet(
      publishedAt: DateTime.parse(json['publishedAt'] ?? ''),
      channelId: json['channelId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnails: Thumbnails.fromJson(json['thumbnails'] ?? {}),
      channelTitle: json['channelTitle'] ?? '',
      liveBroadcastContent: json['liveBroadcastContent'] ?? '',
    );
  }
}

class Thumbnails {
  Thumbnail defaultThumbnail;
  Thumbnail mediumThumbnail;
  Thumbnail highThumbnail;

  Thumbnails({
    required this.defaultThumbnail,
    required this.mediumThumbnail,
    required this.highThumbnail,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      defaultThumbnail: Thumbnail.fromJson(json['default'] ?? {}),
      mediumThumbnail: Thumbnail.fromJson(json['medium'] ?? {}),
      highThumbnail: Thumbnail.fromJson(json['high'] ?? {}),
    );
  }
}

class Thumbnail {
  String url;
  int width;
  int height;

  Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}
