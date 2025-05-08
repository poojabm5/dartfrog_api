import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/src/generated/prisma/prisma_client.dart';
import 'package:my_first/user_repositary.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(_provideUserrepo());
}

final _prisma = PrismaClient(
  datasources: const Datasources(
    db: 'mysql://root:pbudha@5@localhost:3306/mydb?schema=public',
  ),
);

Middleware _provideUserrepo() {
  return provider((context) => UserRepositary(_prisma));
}
