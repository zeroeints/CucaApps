import 'package:flutter/material.dart';
import 'package:apps_cuaca/pages/result.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController placeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                hintText: "Enter City Name",
                hintStyle: const TextStyle(
                  fontFamily: 'SFProDisplay3',
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => result(place: placeController.text),
                      ),
                    );
                  },
                ),
              ),
              style: const TextStyle(
                fontFamily: 'SFProDisplay3',
                color: Colors.white,
              ),
              controller: placeController,
            ),
          ],
        ),
      ),
    );
  }
}
