import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/navigation_cubit.dart';
import 'widget/navigation_state.dart';
import 'pages/home_page.dart';
import 'pages/search_field.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        textTheme: TextTheme(

        ),
      ),
      home: BlocProvider(
        create: (context) => NavigationCubit(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset('lib/image/Image.png', height: 40),
                SizedBox(width: 10),
                Text('Home Page', style: TextStyle(fontSize: 24, color: const Color.fromARGB(255, 0, 0, 0))),
              ],
            ),
           
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.purple],
              ),
            ),
            child: _getPage(state.index),
          ),
          bottomNavigationBar: BottomNavigationBar(
            // backgroundColor: Colors.blue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
            currentIndex: state.index,
            selectedItemColor: Color.fromARGB(255, 60, 0, 255),
            unselectedItemColor: Color.fromARGB(179, 149, 71, 252),
            onTap: (index) {
              context.read<NavigationCubit>().navigateTo(index);
            },
          ),
        );
      },
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      default:
        return Container();
    }
  }
}
