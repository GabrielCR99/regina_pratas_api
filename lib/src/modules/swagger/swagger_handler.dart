import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

Future<Response> swaggerHandler(Request request) async {
  const path = 'specs/swagger.yaml';
  final handler = SwaggerUI(
    path,
    title: 'Regina Pratas API',
    deepLink: true,
  );

  return await handler(request);
}
