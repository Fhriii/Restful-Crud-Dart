import 'package:dotenv/dotenv.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:codock/src/generated/prisma/prisma_client.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';

final env = DotEnv()..load();

final prisma = PrismaClient(
  datasources: Datasources(
    db: env['DATABASE_URL'],
  ),
);

Handler middleware(Handler handler) {
  return handler
    .use(requestLogger())
    .use(cors(
      allowOrigin: '*', // Mengizinkan semua origin
      allowHeaders: 'Content-Type, Authorization', // Daftar header yang diizinkan
      allowMethods: 'GET, POST, PUT, DELETE, OPTIONS', // Daftar metode yang diizinkan
    ))
    .use(provider<PrismaClient>((context) => prisma))
    .use((handler) {
      return (context) async {
        final response = await handler(context);
        if (context.request.method == HttpMethod.options) {
          return response.copyWith(
            headers: { 
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Headers': 'Content-Type, Authorization',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            },
          );
        }
        return response;
      };
    });
}

