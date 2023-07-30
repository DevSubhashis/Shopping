import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ppl/models/category_model.dart';
import 'package:ppl/models/sub_category_model.dart';
import 'package:ppl/models/product_model.dart';
import 'package:ppl/models/brand_model.dart';
import 'package:ppl/models/size_model.dart';
import 'package:ppl/models/color_model.dart';
import 'package:ppl/utils/constants.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class WebService {
  static final WebService _webService = WebService._internal();

  factory WebService() {
    return _webService;
  }

  WebService._internal();

  Future<http.Response> callPostAPI(url, Map body, token) {
    return http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(body),
    );
  }

  Future<http.Response> callGetAPI(url, token) {
    return http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
  }

  Future<http.Response> callGetWithoutToken(url) {
    return http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
  }

  Future<List<CategoryModel>> getCategories(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      // log(responseJson['result']['categories']['data'].toString());
      return (responseJson['result']['categories']['data'] as List)
          .map((data) => CategoryModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<SubCategoryModel>> getSubCategoriesByParentId(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return (responseJson['result']['sub_categories']['data'] as List)
          .map((data) => SubCategoryModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<http.Response> callPatchAPI(url, Map body, token) {
    return http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(body),
    );
  }

  Future<http.Response> callDeleteAPI(url, token) {
    return http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
  }

  Future<http.Response> doUpdateProfile(
    String token,
    Map data,
    File profileImage,
    File coverImage,
  ) async {
    var uri = Uri.parse(UPDATE_PROFILE);
    var request = http.MultipartRequest("POST", uri);
    var stream0, length0, multipartFile0;
    var stream1, length1, multipartFile1;

    if (profileImage != null) {
      stream0 =
          http.ByteStream(DelegatingStream.typed(profileImage.openRead()));
      length0 = await profileImage.length();
      multipartFile0 = http.MultipartFile('profile_picture', stream0, length0,
          filename: basename(profileImage.path));
      request.files.add(multipartFile0);
    }
    if (coverImage != null) {
      stream1 = http.ByteStream(DelegatingStream.typed(coverImage.openRead()));
      length1 = await coverImage.length();
      multipartFile1 = http.MultipartFile('cover_picture', stream1, length1,
          filename: basename(coverImage.path));
      request.files.add(multipartFile1);
    }

    request.fields["first_name"] = data['first_name'];
    request.fields["last_name"] = data['last_name'];
    request.fields["email"] = data['email'];
    request.fields["country_code"] = data['country_code'];
    request.fields["mobile"] = data['mobile'];
    request.fields["date_of_birth"] = data['dob'];
    request.fields["gender"] = data['gender'];

    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  Future<List<ProductModel>> getAllProducts(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      //print(responseJson);
      return (responseJson['result']['products']['data'] as List)
          .map((data) => ProductModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<ProductModel>> getAllProductsByCategory(url, Map body) async {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson);
      return (responseJson['result']['products']['data'] as List)
          .map((data) => ProductModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<BrandModel>> getAllBrands(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson);
      return (responseJson['result']['brands']['data'] as List)
          .map((data) => BrandModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<ColorModel>> getAllColors(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson);
      return (responseJson['result']['product_colors'] as List)
          .map((data) => ColorModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List<SizeModel>> getAllSizes(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return (responseJson['result']['product_sizes'] as List)
          .map((data) => SizeModel.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<ProductModel> getProductDetails(url) async {
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      // print("======= >>>> 1111 ====>>>> ");
      // print(response.body);
      // print("======= >>>> 1111 =====>>> ");
      var responseJson = json.decode(response.body);
      return (ProductModel.fromJson(responseJson['result']['product']));
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<List> addToCart(url, Map body, String token) async {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(body),
    );
    // print("======>>> ADD TO CART , START");
    // print(response.body);
    // print("======>>> ADD TO CART , END ");
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson['result']['cart_items'].toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}
