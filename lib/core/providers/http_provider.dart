import 'package:esp32_app/core/network/http_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider((ref) => HttpClient(http.Client()));
