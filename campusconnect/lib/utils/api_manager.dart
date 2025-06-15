import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiManager{
  static const  String brainWiredApi = "https://jsonplaceholder.typicode.com";

  //GET Methods
  static Future<dynamic> getRequest(url) async {


    try {

      var headers = {
        "Accept": "application/json",
      };

      var request = http.Request('GET', Uri.parse(brainWiredApi + url));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      debugPrint("Status code: ${response.statusCode}");

      return _response1(response);
    } on SocketException {
      throw CustomException(errorMsg: 'Network Connection Failed !');
    } on TimeoutException{
      throw CustomException(errorMsg:  'Takes Too Much Time !');
    }
    on FetchDataException catch (e){
      throw CustomException(errorMsg:  e.errorMsg);
    }
  }




  /// RESPONSE HANDLER
  static dynamic _response1(http.StreamedResponse response) async{
    log("Status Code${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(await response.stream.bytesToString());

        return responseJson;

      case 500:
        throw CustomException(errorMsg: response.reasonPhrase!);

      case 401:
        throw Unauthenticated(errorMsg: response.reasonPhrase!);

      case 422:

        throw CustomException(errorMsg: "Something went wrong");

      case 404:
        throw CustomException(errorMsg: response.reasonPhrase!);

      default:
        throw CustomException(errorMsg: 'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }



}

class CustomException implements Exception {
  String errorMsg;
  CustomException({required this.errorMsg});
}

class Unauthenticated implements Exception {
  String errorMsg;
  Unauthenticated({required this.errorMsg});
}

class FetchDataException implements Exception {
  String errorMsg;
  FetchDataException({required this.errorMsg});
}