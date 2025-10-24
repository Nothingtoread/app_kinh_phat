import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kinh_phat.dart';
import '../models/pdf_library.dart';
import '../utils/debug_logger.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.11:5275/api'; // Updated to use host machine IP
  
  // Helper method for making HTTP requests with logging
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = '$baseUrl$endpoint';
    final stopwatch = Stopwatch()..start();
    
    DebugLogger.networkRequest(method, url, headers: headers, body: body);
    
    try {
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(Uri.parse(url), headers: headers);
          break;
        case 'POST':
          response = await http.post(Uri.parse(url), headers: headers, body: body);
          break;
        case 'PUT':
          response = await http.put(Uri.parse(url), headers: headers, body: body);
          break;
        case 'DELETE':
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
      
      stopwatch.stop();
      DebugLogger.networkResponse(method, url, response.statusCode, 
        responseBody: response.body, duration: stopwatch.elapsed);
      
      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      DebugLogger.networkError(method, url, e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  // Lấy tất cả kinh phật
  static Future<List<KinhPhat>> getAllKinhPhat() async {
    try {
      DebugLogger.apiCall('/KinhPhat');
      final response = await _makeRequest('GET', '/KinhPhat', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final result = jsonList.map((json) => KinhPhat.fromJson(json)).toList();
        DebugLogger.apiSuccess('/KinhPhat', response: result);
        return result;
      } else {
        throw Exception('Lỗi khi lấy danh sách kinh phật: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/KinhPhat', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Lấy kinh sáng
  static Future<List<KinhPhat>> getKinhSang() async {
    try {
      DebugLogger.apiCall('/KinhPhat/sang');
      final response = await _makeRequest('GET', '/KinhPhat/sang', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final result = jsonList.map((json) => KinhPhat.fromJson(json)).toList();
        DebugLogger.apiSuccess('/KinhPhat/sang', response: result);
        return result;
      } else {
        throw Exception('Lỗi khi lấy danh sách kinh sáng: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/KinhPhat/sang', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Lấy kinh tối
  static Future<List<KinhPhat>> getKinhToi() async {
    try {
      DebugLogger.apiCall('/KinhPhat/toi');
      final response = await _makeRequest('GET', '/KinhPhat/toi', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final result = jsonList.map((json) => KinhPhat.fromJson(json)).toList();
        DebugLogger.apiSuccess('/KinhPhat/toi', response: result);
        return result;
      } else {
        throw Exception('Lỗi khi lấy danh sách kinh tối: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/KinhPhat/toi', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Lấy kinh phật theo ID
  static Future<KinhPhat> getKinhPhatById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/KinhPhat/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return KinhPhat.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy kinh phật với ID: $id');
      } else {
        throw Exception('Lỗi khi lấy kinh phật: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API getKinhPhatById: $e');
      rethrow;
    }
  }

  // Lấy kinh phật theo ngày và thời gian
  static Future<KinhPhat> getKinhPhatByDate(DateTime date, String thoiGian) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/KinhPhat/by-date?date=${date.toIso8601String().split('T')[0]}&thoiGian=$thoiGian'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return KinhPhat.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy kinh $thoiGian cho ngày ${date.toIso8601String().split('T')[0]}');
      } else {
        throw Exception('Lỗi khi lấy kinh phật theo ngày: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API getKinhPhatByDate: $e');
      rethrow;
    }
  }

  // Thêm kinh phật mới
  static Future<KinhPhat> addKinhPhat(KinhPhat kinhPhat) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/KinhPhat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(kinhPhat.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return KinhPhat.fromJson(json);
      } else {
        throw Exception('Lỗi khi thêm kinh phật: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API addKinhPhat: $e');
      rethrow;
    }
  }

  // Cập nhật kinh phật
  static Future<void> updateKinhPhat(KinhPhat kinhPhat) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/KinhPhat/${kinhPhat.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(kinhPhat.toJson()),
      );

      if (response.statusCode != 204) {
        throw Exception('Lỗi khi cập nhật kinh phật: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API updateKinhPhat: $e');
      rethrow;
    }
  }

  // Xóa kinh phật
  static Future<void> deleteKinhPhat(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/KinhPhat/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        throw Exception('Lỗi khi xóa kinh phật: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API deleteKinhPhat: $e');
      rethrow;
    }
  }

  // Kiểm tra premium status theo device ID
  static Future<Map<String, dynamic>> checkPremiumStatus(String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Premium/status/$deviceId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Lỗi khi kiểm tra premium status: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API checkPremiumStatus: $e');
      rethrow;
    }
  }

  // Validate purchase receipt
  static Future<Map<String, dynamic>> validatePurchase(Map<String, dynamic> purchaseData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Premium/validate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(purchaseData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Lỗi khi validate purchase: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API validatePurchase: $e');
      rethrow;
    }
  }

  // Register device cho premium
  static Future<Map<String, dynamic>> registerDevice(Map<String, dynamic> deviceData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Premium/register-device'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(deviceData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Lỗi khi register device: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi API registerDevice: $e');
      rethrow;
    }
  }

  // PDF Library API methods
  // Lấy tất cả PDF trong thư viện
  static Future<List<PdfLibrary>> getAllPdfLibraries() async {
    try {
      DebugLogger.apiCall('/PdfLibrary');
      final response = await _makeRequest('GET', '/PdfLibrary', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final result = jsonList.map((json) => PdfLibrary.fromJson(json)).toList();
        DebugLogger.apiSuccess('/PdfLibrary', response: result);
        return result;
      } else {
        throw Exception('Lỗi khi lấy danh sách PDF: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Lấy PDF theo category
  static Future<List<PdfLibrary>> getPdfLibrariesByCategory(String category) async {
    try {
      DebugLogger.apiCall('/PdfLibrary/category/$category');
      final response = await _makeRequest('GET', '/PdfLibrary/category/$category', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final result = jsonList.map((json) => PdfLibrary.fromJson(json)).toList();
        DebugLogger.apiSuccess('/PdfLibrary/category/$category', response: result);
        return result;
      } else {
        throw Exception('Lỗi khi lấy PDF theo category: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary/category/$category', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Lấy PDF theo ID
  static Future<PdfLibrary> getPdfLibraryById(int id) async {
    try {
      DebugLogger.apiCall('/PdfLibrary/$id');
      final response = await _makeRequest('GET', '/PdfLibrary/$id', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final result = PdfLibrary.fromJson(json);
        DebugLogger.apiSuccess('/PdfLibrary/$id', response: result);
        return result;
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy PDF với ID: $id');
      } else {
        throw Exception('Lỗi khi lấy PDF: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary/$id', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Upload PDF (chỉ admin)
  static Future<PdfLibrary> uploadPdf({
    required String title,
    required String description,
    required String category,
    required String author,
    required String createdBy,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      DebugLogger.apiCall('/PdfLibrary', body: {
        'title': title,
        'description': description,
        'category': category,
        'author': author,
        'createdBy': createdBy,
        'fileName': fileName,
      });

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/PdfLibrary'));
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = category;
      request.fields['author'] = author;
      request.fields['createdBy'] = createdBy;
      
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      DebugLogger.networkResponse('POST', '$baseUrl/PdfLibrary', response.statusCode,
        responseBody: response.body);

      if (response.statusCode == 201) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final result = PdfLibrary.fromJson(json);
        DebugLogger.apiSuccess('/PdfLibrary', response: result);
        return result;
      } else {
        throw Exception('Lỗi khi upload PDF: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Cập nhật PDF (chỉ admin)
  static Future<void> updatePdfLibrary(int id, {
    required String title,
    required String description,
    required String category,
    required String author,
  }) async {
    try {
      DebugLogger.apiCall('/PdfLibrary/$id', body: {
        'title': title,
        'description': description,
        'category': category,
        'author': author,
      });

      final response = await _makeRequest('PUT', '/PdfLibrary/$id', 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'description': description,
          'category': category,
          'author': author,
        }));

      if (response.statusCode != 204) {
        throw Exception('Lỗi khi cập nhật PDF: ${response.statusCode}');
      }
      
      DebugLogger.apiSuccess('/PdfLibrary/$id');
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary/$id', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Xóa PDF (chỉ admin)
  static Future<void> deletePdfLibrary(int id) async {
    try {
      DebugLogger.apiCall('/PdfLibrary/$id');
      final response = await _makeRequest('DELETE', '/PdfLibrary/$id', 
        headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 204) {
        throw Exception('Lỗi khi xóa PDF: ${response.statusCode}');
      }
      
      DebugLogger.apiSuccess('/PdfLibrary/$id');
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary/$id', e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Download PDF
  static Future<List<int>> downloadPdf(int id) async {
    try {
      DebugLogger.apiCall('/PdfLibrary/download/$id');
      final response = await http.get(
        Uri.parse('$baseUrl/PdfLibrary/download/$id'),
        headers: {'Content-Type': 'application/pdf'},
      );

      DebugLogger.networkResponse('GET', '$baseUrl/PdfLibrary/download/$id', response.statusCode);

      if (response.statusCode == 200) {
        DebugLogger.apiSuccess('/PdfLibrary/download/$id');
        return response.bodyBytes;
      } else {
        throw Exception('Lỗi khi download PDF: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      DebugLogger.apiError('/PdfLibrary/download/$id', e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
