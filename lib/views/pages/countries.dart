import 'package:countries_info/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//import 'countries.model.dart';
import '../../models/countriesModel.dart';
import '../../services/countriesService.dart';
import 'countryDetail.dart';

// TODO: fetch list of countries from API and render
// Feel free to change this to a stateful widget if necessary
class CountriesPage extends StatefulWidget {
  CountryService get service => GetIt.I<CountryService>();

  @override
  _CountriesPageState createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  List<CountriesModel> countries = List.empty(); //initializng the list that stores list of countries from API response
  List<CountriesModel> listedCountries = List.empty(); //initializing the that will store rendered countries
   

  @override
  void initState() {
    super.initState();
   
    //get countries list from API response using promises
     CountryService.getCountries().then((response) {
      setState(() {
        countries = response;
        listedCountries = countries; //initially render all countries to list
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Countries"),
          actions: [
            IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.about)),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            //create a Search box
            Card(
              margin: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: Icon(Icons.close),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)),
                  labelText: "Search",
                ),
                onChanged: (string) {
                  setState(() {
                    ///assign searched countries to be rendereder
                    listedCountries = countries.where((country) => (country.name.toLowerCase().contains(string.toLowerCase()))).toList();
                  });
                },
              ),
            ),

            //countries list
            Expanded(
              child: ListView.separated(
                itemCount: listedCountries.length ,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(
                       color: Colors.grey,
                       height: 5,
                       thickness: 5,
                    ),
                itemBuilder: (BuildContext context, int index) { //use item builder to render items when we recieve them
                  return ListTile(
                    onTap: () {
                      //navigate to the next screen
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CountryDetailPage()));
                    },
                    leading: Image(
                      image:  NetworkImage(listedCountries[index].flag),
                    ),
                     title: Text(listedCountries[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
                     subtitle: Text(listedCountries[index].capital),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
