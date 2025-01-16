class SignUpResult {
  final bool isSuccess;
  final String? userId;
  final String? message;

  SignUpResult.success(this.userId) : isSuccess = true, message = null;

  SignUpResult.failure(this.message)
      : isSuccess = false,
        userId = null;
}
