import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/config.dart';

/// Service class for making API calls to Appwrite backend
class AppwriteService {
  final String endpoint;
  final String projectId;
  final String apiKey;
  final String databaseId;

  /// Creates an instance of AppwriteService with necessary configuration
  AppwriteService({
    String? endpointUrl,
    String? projectIdentifier,
    String? apiKeyValue,
    String? databaseIdentifier,
  })  : endpoint =
            (endpointUrl ?? appwriteEndpoint).replaceAll(RegExp(r'/$'), ''),
        projectId = projectIdentifier ?? appwriteProjectId,
        apiKey = apiKeyValue ?? appwriteApiKey,
        databaseId = databaseIdentifier ?? appwriteDatabaseId;

  /// Standard headers used in API requests
  Map<String, String> get _standardHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'X-Appwrite-Project': projectId,
      'X-Appwrite-Response-Format': '1.5.0',
    };

    if (apiKey.isNotEmpty) {
      headers['X-Appwrite-Key'] = apiKey;
    }

    return headers;
  }

  /// Makes an HTTP request to the Appwrite API
  ///
  /// [method] - HTTP method (GET, POST, PUT, DELETE, PATCH)
  /// [endpointPath] - API endpoint path
  /// [data] - Request payload (optional)
  /// [queryParameters] - URL query parameters (optional)
  /// [queryParametersAll] - Query parameters with repeated keys (optional)
  Future<http.Response> makeRequest({
    required String method,
    required String endpointPath,
    Map<String, dynamic>? data,
    Map<String, String>? queryParameters,
    Map<String, List<String>>? queryParametersAll,
  }) async {
    final cleanedPath =
        endpointPath.startsWith('/') ? endpointPath.substring(1) : endpointPath;

    final baseUri = Uri.parse('$endpoint/$cleanedPath');

    Uri uri;

    if (queryParametersAll != null && queryParametersAll.isNotEmpty) {
      final queryParts = <String>[];

      queryParametersAll.forEach((key, values) {
        for (final value in values) {
          queryParts.add(
            '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value)}',
          );
        }
      });

      final queryString = queryParts.join('&');
      uri = Uri.parse('${baseUri.toString()}?$queryString');
    } else {
      uri = baseUri.replace(queryParameters: queryParameters);
    }

    developer.log('Making $method request to $uri');

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: _standardHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: _standardHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: _standardHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            uri,
            headers: _standardHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: _standardHeaders,
            body: data != null ? jsonEncode(data) : null,
          );
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      _logResponse(response);
      return response;
    } catch (e) {
      developer.log(
        'Error making request to $uri: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  /// Uploads a file to the Appwrite storage
  ///
  /// [bucketId] - ID of the storage bucket
  /// [file] - File to upload
  /// [fileId] - ID to assign to the file (optional)
  /// [permissions] - File permissions (optional)
  Future<Map<String, dynamic>> uploadFile({
    required String bucketId,
    required File file,
    String? fileId,
    List<String>? permissions,
  }) async {
    final endpointPath = 'storage/buckets/$bucketId/files';
    final url = Uri.parse('$endpoint/$endpointPath');

    try {
      developer.log('===== FILE UPLOAD START =====');
      developer.log('Bucket ID: $bucketId');
      developer.log('File path: ${file.path}');
      developer.log('Upload URL: $url');
      developer.log('Endpoint: $endpoint');

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'X-Appwrite-Project': projectId,
          if (apiKey.isNotEmpty) 'X-Appwrite-Key': apiKey,
        });

      developer.log('Headers: ${request.headers}');

      if (fileId != null && fileId.isNotEmpty) {
        request.fields['fileId'] = fileId;
        developer.log('Added fileId: $fileId');
      } else {
        request.fields['fileId'] = 'unique()';
      }

      if (permissions != null && permissions.isNotEmpty) {
        for (final permission in permissions) {
          request.fields.putIfAbsent('permissions[]', () => permission);
        }
        developer.log('Added permissions: $permissions');
      }

      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      developer.log('Added file to request');

      developer.log('Sending upload request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      developer.log('Upload response status: ${response.statusCode}');
      developer.log('Upload response body: ${response.body}');

      _logResponse(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        developer.log('===== FILE UPLOAD SUCCESS =====');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        developer.log('===== FILE UPLOAD FAILED =====');
        throw Exception('Failed to upload file: ${response.body}');
      }
    } catch (e) {
      developer.log(
        '===== FILE UPLOAD ERROR =====',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  /// Fetches documents from a collection
  ///
  /// [collectionId] - ID of the collection
  /// [queries] - List of query constraints (optional)
  Future<Map<String, dynamic>> listDocuments({
    required String collectionId,
    List<String>? queries,
  }) async {
    Map<String, List<String>>? queryParamsAll;

    if (queries != null && queries.isNotEmpty) {
      queryParamsAll = {
        'queries[]': queries,
      };
    }

    developer.log('List documents queries: $queries');

    try {
      final response = await makeRequest(
        method: 'GET',
        endpointPath:
            'databases/$databaseId/collections/$collectionId/documents',
        queryParametersAll: queryParamsAll,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to list documents: ${response.body}');
      }
    } catch (e) {
      developer.log('Error listing documents: $e');
      rethrow;
    }
  }

  /// Deletes a document from a collection
  ///
  /// [collectionId] - ID of the collection
  /// [documentId] - ID of the document to delete
  Future<void> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    final endpointPath =
        'databases/$databaseId/collections/$collectionId/documents/$documentId';

    try {
      final response = await makeRequest(
        method: 'DELETE',
        endpointPath: endpointPath,
      );

      if (response.statusCode == 204) {
        developer.log('Document deleted successfully');
      } else {
        developer.log(
          'Failed to delete document. Status: ${response.statusCode}, Response: ${response.body}',
        );
        throw Exception('Failed to delete document: ${response.body}');
      }
    } catch (e) {
      developer.log('Error deleting document: $e');
      rethrow;
    }
  }

  /// Creates a document in a collection
  ///
  /// [collectionId] - ID of the collection
  /// [data] - Document data
  /// [documentId] - ID to assign to the document (optional)
  Future<Map<String, dynamic>> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    final endpointPath =
        'databases/$databaseId/collections/$collectionId/documents';

    final Map<String, dynamic> requestData = {
      'documentId': documentId ?? 'unique()',
      'data': data.containsKey('data') ? data['data'] : {...data},
    };

    if (data.containsKey('permissions')) {
      requestData['permissions'] = data['permissions'];
    }

    try {
      developer.log('===== CREATE DOCUMENT START =====');
      developer.log('Collection: $collectionId');
      developer
          .log('Creating document with payload: ${jsonEncode(requestData)}');

      final response = await makeRequest(
        method: 'POST',
        endpointPath: endpointPath,
        data: requestData,
      );

      developer.log('Response Status: ${response.statusCode}');
      developer.log('Response Body (FULL): ${response.body}');

      if (response.statusCode == 201) {
        developer.log('===== CREATE DOCUMENT SUCCESS =====');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        developer.log('===== CREATE DOCUMENT FAILED =====');
        developer
            .log('Status ${response.statusCode}: ${response.reasonPhrase}');
        developer.log('Error Response: ${response.body}');
        throw Exception('Failed to create document: ${response.body}');
      }
    } catch (e, st) {
      developer.log('===== CREATE DOCUMENT ERROR =====');
      developer.log('Exception: $e');
      developer.log('Stack Trace: $st');
      rethrow;
    }
  }

  /// Updates a document in a collection
  ///
  /// [collectionId] - ID of the collection
  /// [documentId] - ID of the document you want to update
  /// [data] - Updated fields as a map
  Future<http.Response> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final endpointPath =
        'databases/$databaseId/collections/$collectionId/documents/$documentId';

    final requestData = {
      'data': data.containsKey('data') ? data['data'] : {...data},
    };

    if (data.containsKey('permissions')) {
      requestData['permissions'] = data['permissions'];
    }

    return await makeRequest(
      method: 'PATCH',
      endpointPath: endpointPath,
      data: requestData,
    );
  }

  /// Logs the API response for debugging purposes
  void _logResponse(http.Response response) {
    final statusPrefix =
        response.statusCode >= 200 && response.statusCode < 300 ? '✅' : '❌';
    developer.log(
      '$statusPrefix Response ${response.statusCode}: ${response.reasonPhrase}',
      name: 'AppwriteService',
    );

    final bodyPreview = response.body.length > 500
        ? '${response.body.substring(0, 500)}...'
        : response.body;
    developer.log('Response body: $bodyPreview', name: 'AppwriteService');
  }
}
