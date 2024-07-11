import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class result extends StatefulWidget {
  final String place; //menangkap kota
  const result({super.key, required this.place});

  @override
  State<result> createState() => _ResultState();
}

class _ResultState extends State<result> {
  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=47c37c999d0edcf40a9235b2817c55a0&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Cuaca App',
              style: TextStyle(
                fontFamily: 'SFProDisplay2',
                color: Colors.white,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: FrostedGlassBox(
              theChild: FutureBuilder<Map<String, dynamic>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return ListView(
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                           "${data["name"]}",
                            style: const TextStyle(
                              fontFamily: 'SFProDisplay2',
                              fontSize: 34,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              "${data["main"]["temp"].toInt()}°",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay2',
                                fontSize: 70,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            data["weather"][0]["description"],
                            style: const TextStyle(
                              fontFamily: 'SFProDisplay1',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Image.network(
                            'http://openweathermap.org/img/w/${data["weather"][0]["icon"]}.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop_outlined,
                                size: 20, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "${data["main"]["humidity"]}% ",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Icon(Icons.air,
                                size: 20, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "${data["wind"]["speed"]} m/s",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Min: ${data["main"]["temp_min"].toInt()}° ",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Max: ${data["main"]["temp_max"].toInt()}°",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sunny,
                                size: 20, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "Sunrise: ${DateTime.fromMillisecondsSinceEpoch(data["sys"]["sunrise"] * 1000).toLocal().toIso8601String().substring(11, 16)}",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.nightlight_round,
                                size: 20, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              "Sunset: ${DateTime.fromMillisecondsSinceEpoch(data["sys"]["sunset"] * 1000).toLocal().toIso8601String().substring(11, 16)}",
                              style: const TextStyle(
                                fontFamily: 'SFProDisplay1',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Location not found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({required this.theChild});

  final Widget theChild;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: theChild,
          ),
        ),
      ),
    );
  }
}
