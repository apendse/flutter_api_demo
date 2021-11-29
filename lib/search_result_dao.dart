import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<SearchResults> fetchResults(String query) async {
  final urlString = "https://www.flickr.com/services/feeds/photos_public.gne?tags=$query&format=json";
  final response = await http.get(Uri.parse(urlString));
  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    return SearchResults.fromJson(body);
  } else {
    throw Exception("Network error");
  }
}

class SearchResults {
  final String title;
  final String link;
  final List<ImageData> items;
  SearchResults({required this.title, required this.link, required this.items});

  factory SearchResults.fromJson(String str) {
    String jsonString = getJsonString(str);
    Map<String, dynamic> map = jsonDecode(jsonString);
    String title = map['title'] as String;
    String link = map['link'] as String;
    List<dynamic> itemList = map['items'];
    List<ImageData> list = List.generate(itemList.length, (index) {
      Map<String, dynamic> map = itemList[index];
      return ImageData.fromJson(map);
    }
    );
    return SearchResults(title: title, link: link, items: list);
  }
  
  static String getJsonString(String str) {
    String prefix = "jsonFlickrFeed(";
    int index = str.indexOf(prefix);
    int start = 0;
    if (index >= 0) {
      start = prefix.length;
    }
    String suffix = ")";
    int endIndex = str.lastIndexOf(suffix);
    int end = str.length;
    if (endIndex >= 0) {
      end = end - suffix.length;
    }
    return str.substring(start, end);
  }
}

class ImageData {
  final String imageUrl;
  final String title;
  ImageData({required this.imageUrl, required this.title});
  factory ImageData.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> media = map['media'];
    String imageUrl = media['m'];
    String title = map['title'];
    return ImageData(imageUrl: imageUrl, title: title);
  }
}