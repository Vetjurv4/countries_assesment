import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/countriesModel.dart';
import '../constants/strings.dart';

class CountryService{

  /** 
   * get the list of all the countries
   * @return List<Countries>
   */
  static Future<List<CountriesModel>> getCountries() async{
    //initialize an empty list
    List<CountriesModel> countriesList = List.empty();

    try{
       //send get hppt request
      final response = await http.get(Strings.countries_url);
         //checking if the response is 200/successful
        if(response.statusCode == 200){
            final jsonString = response.body; //getting response body
            final jsonMap = json.decode(jsonString).cast<Map<String, dynamic>>(); 

            countriesList = jsonMap.map<CountriesModel>((json) => CountriesModel.fromJson(json)).toList(); //mapping json response   into a Model
        }
    }catch(e){
      throw Exception(e.toString());
    }

    return countriesList; //list of countries
  }

}
