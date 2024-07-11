import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apps_cuaca/database/db_helper.dart';
import 'form.dart';
import 'result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _cityList;

  @override
  void initState() {
    super.initState();
    _cityList = DBHelper().getCities();
  }

  Future<Map<String, dynamic>> getData(String place) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$place&appid=47c37c999d0edcf40a9235b2817c55a0&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("ERROR");
    }
  }

  void deleteCity(int id) async {
    await DBHelper().deleteCity(id);
    setState(() {
      _cityList = DBHelper().getCities();
    });
  }

  void _showDeleteConfirmationDialog(int cityId, String cityName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $cityName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteCity(cityId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCityDialog(int cityId, String cityName) {
    final TextEditingController _controller =
        TextEditingController(text: cityName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit City'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'City Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                DBHelper().updateCity(cityId, _controller.text);
                setState(() {
                  _cityList = DBHelper().getCities();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Cities',
            style: TextStyle(
                fontFamily: 'SFProDisplay2',
                fontSize: 24,
                color: Colors.white)),
        // centerTitle: true,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _cityList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white, fontSize: 18)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No cities added yet.',
                      style: TextStyle(color: Colors.white, fontSize: 18)));
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(top: 50),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final city = snapshot.data![index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: getData(city['name']),
                    builder: (context, weatherSnapshot) {
                      if (weatherSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: Text(city['name'],
                              style: TextStyle(color: Colors.white)),
                          trailing: CircularProgressIndicator(),
                        );
                      } else if (weatherSnapshot.hasError) {
                        return ListTile(
                          title: Text(city['name'],
                              style: TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.white, size: 20),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      city['id'], city['name']);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                                onPressed: () {
                                  _showEditCityDialog(city['id'], city['name']);
                                },
                              ),
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      } else if (!weatherSnapshot.hasData) {
                        return ListTile(
                          title: Text(city['name'],
                              style: TextStyle(color: Colors.white)),
                          trailing: Text('No data',
                              style: TextStyle(color: Colors.white)),
                        );
                      } else {
                        final weatherData = weatherSnapshot.data!;
                        return ListTile(
                          title: Text(
                            city['name'],
                            style: const TextStyle(
                              fontFamily: 'SFProDisplay1',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '${weatherData['main']['temp'].toInt()}°C, ${weatherData['weather'][0]['description']}',
                            style: const TextStyle(
                              fontFamily: 'SFProDisplay3',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete_forever_outlined,
                                    color: Colors.white, size: 20),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      city['id'], city['name']);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                                onPressed: () {
                                  _showEditCityDialog(city['id'], city['name']);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility,
                                    color: Colors.white, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          result(place: city['name']),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CityForm()),
          ).then((_) {
            setState(() {
              _cityList = DBHelper().getCities();
            });
          });
        },
        child: Icon(Icons.add, size: 20),
      ),
    );
  }
}
