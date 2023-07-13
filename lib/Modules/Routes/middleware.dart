import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:mi_fik/Modules/Routes/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteGuard extends GetMiddleware {
  Future<RouteSettings> redirectRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    return token == null
        ? const RouteSettings(name: CollectionRoute.landing)
        : null;
  }
}
