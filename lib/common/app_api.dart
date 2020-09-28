class AppApiAddress {
  static const String login = '/auth/token';
  static const String refreshToken = '/auth/refresh';
  static const String registeDevice = '/auth/apikey';

  static const String userInfo = '/settings/user';
  static const String serverVersion = '/info/version';

  static const String posts = '/hexoeditorserver/posts';
  static const String post = '/hexoeditorserver/post/{id}';
  static const String postPublish = '/hexoeditorserver/post/{id}/publish';
  static const String postUnpublish = '/hexoeditorserver/post/{id}/unpublish';

  static const String tags = '/hexoeditorserver/tags';
  static const String categories = '/hexoeditorserver/categories';

  static const String reloadBlog = '/hexoeditorserver/reload';
  static const String deployBlog = '/hexoeditorserver/deploy';
  static const String cleanHexo = '/hexoeditorserver/clean';
}
