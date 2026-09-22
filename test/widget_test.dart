import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/router/route_names.dart';

void main() {
  test('RouteNames builds dynamic route paths', () {
    expect(
      RouteNames.serviceListingFor('restaurants', 1),
      '/service-listing/restaurants?sectionId=1',
    );
    expect(
      RouteNames.restaurantDetailFor('az-al-sham'),
      '/restaurant/az-al-sham',
    );
    expect(
      RouteNames.restaurantSearchFor('az-al-sham'),
      '/restaurant/az-al-sham/search',
    );
    expect(RouteNames.orderDetailFor('design'), '/order/design');
  });
}
