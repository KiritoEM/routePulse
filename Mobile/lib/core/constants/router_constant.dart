class RouterConstant {
  static const DEFAULT_ROUTE = '/';
  static const LOGIN_ROUTE = '/login';
  static const SIGNUP_STEP1_ROUTE = '/signup/user_infos';
  static const SIGNUP_STEP2_ROUTE = '/signup/validate-otp';
  static const SIGNUP_STEP3_ROUTE = '/signup/create-password';
  static const DELIVERIES_ROUTE = '/deliveries';
  static const CREATE_DELIVERY_STEP1 = '/create-delivery/client-infos';
  static const CREATE_DELIVERY_STEP2 = '/create-delivery/plannification';

  // Bottom Navigation Routes
  static const List<Map<String, dynamic>> BOTTOM_NAVIGATION_ROUTES = [
    {
      'route': '',
      'label': 'Accueil',
      'icon': 'assets/icons/home.svg',
      'icon_width': 23.0,
    },
    {
      'route': DELIVERIES_ROUTE,
      'label': 'Livraisons',
      'icon': 'assets/icons/package.svg',
      'icon_width': 23.0,
    },
    {
      'route': '',
      'label': 'Carte',
      'icon': 'assets/icons/location.svg',
      'icon_width': 23.0,
    },
    {
      'route': '',
      'label': 'Statistiques',
      'icon': 'assets/icons/stats.svg',
      'icon_width': 23.0,
    },
  ];
}
