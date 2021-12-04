import 'package:flutter/material.dart';
import 'package:flutter_api_demo/srp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = "Flickr Search";
    String query = "";

    return MaterialApp(
      title: 'Search for something',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: SearchStartPage(),
      ),
      routes: {
        SearchResultsPage.routeName: (context)
        {

          return const SearchResultsPage();
        }
      },
    );
  }
}

class SearchStartPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  SearchStartPage({Key? key}) : super(key: key);
  final myTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key:_formKey,

        child: Center(

            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                const SizedBox(width:20),
                Expanded(
                  child: TextFormField(
                      decoration: const InputDecoration(hintText: 'Search for something'),
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        //String query = myTextEditingController.text;
                        Navigator.pushNamed(context, SearchResultsPage.routeName, arguments: myTextEditingController.text);
                      },
                      controller: myTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid search text';
                        }
                        return null;
                      }

                  ),
                  flex: 2,
                ),

                const SizedBox(width: 20),
                getButton(context),
                // Expanded(
                //   child: IconButton(
                //
                //     onPressed:() {
                //       if (_formKey.currentState!.validate()) {
                //         //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You clicked search ${myController.text}")));
                //         Navigator.pushNamed(context, SearchResultsPage.routeName, arguments: myController.text);
                //       }
                //     },
                //     icon: const Icon(Icons.image_search_outlined, size: 25.0, color:Colors.black),
                //     ),
                //
                // ),
                const SizedBox(width:10),
              ],  // children
            )
        )
    );

  }

  Widget getButton(BuildContext context) {
    var assetsImage = const AssetImage('assets/search_icon.png');
    return MaterialButton(
      elevation: 8.0,
      color: const Color.fromARGB(0xff, 0x98, 0x98, 0xF8),
      child: Container(

        padding: const EdgeInsets.all(4.0),
        child: Image(image: assetsImage, width:24, height:24),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
                Navigator.pushNamed(context, SearchResultsPage.routeName, arguments: myTextEditingController.text);
        }
      },
    );
  }
}




