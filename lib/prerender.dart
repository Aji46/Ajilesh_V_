// bin/prerender.dart — pure Dart (no Flutter).
//
//   flutter build web --release
//   dart run bin/prerender.dart
//
// Writes build/web/<route>/index.html for every route (title, meta tags,
// OpenGraph, JSON-LD breadcrumbs and the semantic HTML body), plus
// sitemap.xml, robots.txt, llms.txt and 404.html. Deploy build/web as usual.

import 'package:ajilesh_portfolio/seo_routes.dart';
import 'package:esen_seo/server.dart';


Future<void> main() async {
  await prerenderSite(routes: seoRoutes, siteBase: siteBase);
}
