import 'package:flutter_dotenv/flutter_dotenv.dart';

final String appwriteEndpoint =
    dotenv.env['APPWRITE_URL'] ?? 'http://localhost/v1';

final String appwriteProjectId = dotenv.env['APPWRITE_PROJECT_ID'] ?? '';

final String appwriteApiKey = dotenv.env['APPWRITE_API_KEY'] ?? '';

final String appwriteDatabaseId = dotenv.env['APPWRITE_DATABASE_ID'] ?? '';

final String appwriteBucketId = dotenv.env['APPWRITE_BUCKET_ID'] ?? '';
