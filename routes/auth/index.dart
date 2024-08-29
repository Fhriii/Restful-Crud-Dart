import 'package:codock/src/generated/prisma/prisma_client.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context)
async{
  return switch (context.request.method){
    HttpMethod.get => await _getUser(context),
    HttpMethod.post => await _create(context),
    _ => _notFound(),
  };
}
Future<Response> _getUser(RequestContext context)async{
  final prisma = context.read<PrismaClient>();
  try {
    final user=(await prisma.user.findMany()).toList();
    return Response.json(body: user);
    
  } catch (e) {
    print(e);
    return _notFound();
  }
    
 
  
}
Future<Response> _create(RequestContext context)async{
  final jsonBody= await context.request.json();
  final username=jsonBody['username'] as String;
  final password=jsonBody['password'] as String;
  final prisma = context.read<PrismaClient>();
  final userCreated=(await prisma.user.create(data: UserCreateInput(password: password,username: username)));
  return Response.json(body: userCreated);
}
Response _notFound(){
  return Response.json(statusCode: 404);
}