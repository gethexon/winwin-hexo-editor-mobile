class AppApiAddress {
  static const String login = '/token';
  static const String refreshToken = '/token/refresh';
  static const String posts = '/hexoeditorserver/posts';
  static const String post = '/hexoeditorserver/post/{id}';
  static const String postPublish = '/hexoeditorserver/post/{id}/publish';
  static const String postUnpublish = '/hexoeditorserver/post/{id}/unpublish';
  static const String reloadBlog = '/hexoeditorserver/reload';
  static const String deployBlog = '/hexoeditorserver/deploy';
}