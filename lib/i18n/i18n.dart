class Ids {
  static final String appTitle = 'appTitle';
  static final String loginPageServerHint = 'loginPage_serverHint';
  static final String loginPageUserHint = 'loginPage_userHint';
  static final String loginPagePasswordHint = 'loginPage_passwordHint';
  static final String loginPageLoginButton = 'loginPageLoginButton';
  static final String loadingAlertText = 'loadingAlertText';
  static final String homePageListEmptyText = 'homePageListEmptyText';
  static final String commonNetworkError = 'commonNextWorkError';
}

Map<String, Map<String, Map<String, String>>> localizedValues = {
  'en': {
    'US': {
      Ids.appTitle: 'Hexo winwin editor',
      Ids.loginPageServerHint: 'Your winwin address (eg. http://xxx:577)',
      Ids.loginPageUserHint: 'Your winwin user name (default: admin)',
      Ids.loginPagePasswordHint: 'Your winwin password (default: admin)',
      Ids.loginPageLoginButton: 'Login',
      Ids.loadingAlertText: 'Loading...',
      Ids.homePageListEmptyText: 'Empty',
      Ids.commonNetworkError: 'Network Error',
    }
  },
  'zh': {
    'CN': {
      Ids.appTitle: 'Hexo winwin 编辑器',
      Ids.loginPageServerHint: '您的winwin地址 (例如：http://xxx:5777)',
      Ids.loginPageUserHint: '您的winwin登录名（默认admin)',
      Ids.loginPagePasswordHint: '您的winwin密码（默认admin)',
      Ids.loginPageLoginButton: '登录',
      Ids.loadingAlertText: '请求中...',
      Ids.homePageListEmptyText: '空的呢~',
      Ids.commonNetworkError: '网络请求错误',
    },
  }
};
