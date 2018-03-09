library page_view_component;

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:honeydew/services.dart' as services;
import 'package:honeydew/components.dart' as components;

@Component(
    selector: 'page-view',
    templateUrl: 'page_view.html',
    styleUrls: ['page_view.css'],
    directives: [routerDirectives],
    providers: const [services.SocketService, routerProviders])
class PageViewComponent {
  services.SocketService socketService;
  final Router router;

  static final mainRoute = new RoutePath(
    path: "/",
    useAsDefault: true,
  );

  final List<RouteDefinition> routes = [
    new RouteDefinition(
      routePath: mainRoute,
      component: components.SearchComponentNgFactory,
    ),
  ];

  PageViewComponent(this.socketService, this.router) {
    router.onRouteActivated.listen((RouterState data) {
    });
  }
}
