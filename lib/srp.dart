import 'package:flutter/material.dart';
import 'package:flutter_api_demo/search_result_dao.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({Key? key}) : super(key: key);
  static const routeName = '/showResultList';

  @override
  State<StatefulWidget> createState() {
    return SearchResultsState();
  }
}

class SearchResultsState extends State<SearchResultsPage> {
  late Future<SearchResults> futureSearchResults;
  SearchResults? searchResults = null;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    futureSearchResults = fetchResults(args);
    const itemCount = 0;

    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Extracted $args")));
    log("args $args");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Center(
        child: FutureBuilder<SearchResults>(
          future: futureSearchResults,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              searchResults = snapshot.data!;
              return ListView.builder(itemCount: searchResults!.items.length, itemBuilder: getMyItemBuilder(searchResults!));
            } else if(snapshot.hasError) {
              return Text("There was an error ${snapshot.error}");
            }
            return createMySpinner(args);
          },
        )


      ),


    );
  }

  IndexedWidgetBuilder getMyItemBuilder(SearchResults results) {
    return (_, index) {
      ImageData imageData = results.items[index];
      Color colorEven =  const Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF);
      Color colorOdd =  const Color.fromARGB(0xFF, 0xAA, 0xAA, 0xBB);
      Color color = index % 2 == 0 ? colorEven : colorOdd;
      return
      Container (
        color:color,
        child: Column(
          children: [
            const SizedBox(height: 5,),
            Image.network(imageData.imageUrl),
            const SizedBox(height: 8,),
            Text(imageData.title),
            const SizedBox(height: 5,),
          ],
        )
      );
    };
  }

  Widget createMySpinner(String arg) {
    return Center(

      //padding: const EdgeInsets.only(left:0.0, top:100.0, right:0, bottom:5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          const CircularProgressIndicator(),
          const SizedBox(height:20),
          Text("Searching for $arg..."),
        ],
      )
    ); 
  }
  
}

