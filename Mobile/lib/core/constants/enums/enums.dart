enum NetworkErrorType {
  unknown,
  network,
  server,
  badRequest,
  notFound,
  forbidden,
  unauthorized,
  client,
  canceled,
  conflict,
  tooManyRequest
}

enum JwtVerifyResult {
  expired,
  success,
  error
}
