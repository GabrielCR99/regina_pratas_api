import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

Response notFoundHandler(request) => Response.notFound(
      jsonEncode({
        'timestamp': HttpDate.format(DateTime.now()),
        'status': HttpStatus.notFound,
        'message': 'Not found',
        'path': request.url.path,
      }),
    );
