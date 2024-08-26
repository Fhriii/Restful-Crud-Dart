
import 'package:dotenv/dotenv.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:codock/src/generated/prisma/prisma_client.dart';

final env = DotEnv()..load();

final prisma = PrismaClient(
  datasources: Datasources(
    db: env['DATABASE_URL'],
  ),
);

Handler middleware(Handler handler) {
  return handler
    .use(requestLogger())
    .use(provider<PrismaClient>((context) => prisma));
}
