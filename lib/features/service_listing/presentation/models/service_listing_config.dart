import 'package:flutter/material.dart';
import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/features/service_listing/presentation/models/service_listing_type.dart';
import 'package:food_user_app/l10n/app_localizations.dart';

class ServiceListingConfig {
  const ServiceListingConfig({
    required this.type,
    required this.title,
    required this.searchHint,
    required this.categories,
    required this.groups,
    this.filters = const [],
  });

  final ServiceListingType type;
  final String title;
  final String searchHint;
  final List<ServiceCategoryData> categories;
  final List<ServiceFilterData> filters;
  final List<ServiceListingGroupData> groups;

  static List<ServiceFilterData> topFilters(AppLocalizations l10n) {
    return [
      ServiceFilterData(
        id: ServiceFilterId.offers,
        label: l10n.serviceFilterOffers,
      ),
      ServiceFilterData(
        id: ServiceFilterId.fastDelivery,
        label: l10n.serviceFilterFastDelivery,
      ),
      ServiceFilterData(
        id: ServiceFilterId.topRated,
        label: l10n.serviceFilterTopRated,
      ),
    ];
  }

  static List<ServiceCategoryData> allServiceCategories(AppLocalizations l10n) {
    return _uniqueCategories([
      ..._restaurantCategories(l10n),
      ..._groceryCategories(l10n),
      ..._storeCategories(l10n),
      ..._pickupCategories(l10n),
    ]);
  }

  static ServiceListingConfig of(
    AppLocalizations l10n,
    ServiceListingType type,
  ) {
    return switch (type) {
      ServiceListingType.restaurants => _restaurants(l10n),
      ServiceListingType.grocery => _grocery(l10n),
      ServiceListingType.stores => _stores(l10n),
      ServiceListingType.pickup => _pickup(l10n),
    };
  }

  static ServiceListingConfig _restaurants(AppLocalizations l10n) {
    final kira = ServicePlaceData.restaurant(
      name: l10n.serviceRestaurantKira,
      subtitle: l10n.serviceRestaurantDescription,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.homeRestaurantCover,
      rating: '4.6',
      hasOffer: true,
    );
    final azAlSham = ServicePlaceData.restaurant(
      name: l10n.serviceRestaurantAzAlSham,
      subtitle: l10n.serviceRestaurantDescription,
      time: l10n.serviceDeliveryTime25To40,
      imageAsset: AppAssets.favoriteRestaurantAzAlSham,
      rating: '4.8',
      fastDelivery: true,
    );
    final restaurantMocks = [kira, azAlSham];

    return ServiceListingConfig(
      type: ServiceListingType.restaurants,
      title: l10n.serviceListingRestaurantsTitle,
      searchHint: l10n.serviceSearchHint,
      filters: topFilters(l10n),
      categories: _restaurantCategories(l10n),
      groups: [
        ServiceListingGroupData(
          title: l10n.serviceCategoryDesserts,
          items: _repeat(restaurantMocks, 10),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryGrills,
          items: _repeat(restaurantMocks.reversed.toList(), 10),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryPizza,
          items: _repeat([azAlSham, kira], 10),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryFastFood,
          items: _repeat([kira, azAlSham], 10),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryBurger,
          items: _repeat([azAlSham, kira], 10),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryShawarma,
          items: _repeat([kira, azAlSham], 10),
        ),
      ],
    );
  }

  static ServiceListingConfig _grocery(AppLocalizations l10n) {
    final captain = ServicePlaceData.store(
      name: l10n.serviceStoreCaptain,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.serviceGroceryCaptain,
      rating: '4.5',
      hasOffer: true,
      topRated: false,
    );
    final fathallah = ServicePlaceData.store(
      name: l10n.serviceStoreFathallah,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.serviceGroceryFathallah,
      rating: '4.6',
      fastDelivery: true,
    );
    final groceryMocks = [captain, fathallah];

    return ServiceListingConfig(
      type: ServiceListingType.grocery,
      title: l10n.serviceListingGroceryTitle,
      searchHint: l10n.serviceSearchHint,
      filters: topFilters(l10n),
      categories: _groceryCategories(l10n),
      groups: [
        ServiceListingGroupData(
          title: l10n.serviceCategorySupermarket,
          largeItems: groceryMocks,
          items: _repeat(groceryMocks, 5),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategorySnacks,
          items: _repeat([captain, fathallah], 4),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryDairy,
          largeItems: [fathallah],
          items: _repeat([fathallah, captain], 4),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryFruitsVegetables,
          largeItems: groceryMocks,
          items: _repeat([captain, fathallah], 4),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryRoasters,
          items: _repeat([fathallah, captain], 4),
        ),
      ],
    );
  }

  static ServiceListingConfig _stores(AppLocalizations l10n) {
    final beauty = ServicePlaceData.store(
      name: l10n.serviceCategoryPerfumeBeauty,
      time: l10n.serviceDeliveryTime35To50,
      imageAsset: AppAssets.serviceStoresBeauty,
      rating: '4.5',
      hasOffer: true,
      topRated: false,
    );
    final flowers = ServicePlaceData.store(
      name: l10n.serviceCategoryFlowers,
      time: l10n.serviceDeliveryTime25To40,
      imageAsset: AppAssets.serviceStoresFlowers,
      rating: '4.7',
      fastDelivery: true,
    );
    return ServiceListingConfig(
      type: ServiceListingType.stores,
      title: l10n.serviceListingStoresTitle,
      searchHint: l10n.serviceSearchHint,
      filters: topFilters(l10n),
      categories: _storeCategories(l10n),
      groups: [
        ServiceListingGroupData(
          title: l10n.serviceCategoryPerfumeBeauty,
          items: _repeat([beauty, flowers], 10),
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryFlowers,
          items: _repeat([flowers, beauty], 10),
        ),
      ],
    );
  }

  static ServiceListingConfig _pickup(AppLocalizations l10n) {
    final rimasLand = ServicePlaceData.pickup(
      name: l10n.serviceStoreRimasLand,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupRimas,
      rating: '4.5',
      hasOffer: true,
      topRated: true,
      fastDelivery: false,
    );
    final taheraFry = ServicePlaceData.pickup(
      name: l10n.serviceStoreTaheraFry,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupTahera,
      rating: '4.5',
      hasOffer: true,
      topRated: true,
      fastDelivery: true,
    );
    final familyMarket = ServicePlaceData.pickup(
      name: l10n.serviceStoreFamilyMarket,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupFamily,
      rating: '4.5',
      hasOffer: false,
      topRated: true,
      fastDelivery: false,
    );
    final captainMarket = ServicePlaceData.pickup(
      name: l10n.serviceCaptainMarket,
      time: l10n.serviceDeliveryTimeRange,
      imageAsset: AppAssets.servicePickupCaptain,
      rating: '4.5',
      hasOffer: false,
      topRated: false,
      fastDelivery: true,
    );
    final pickupItems = [rimasLand, taheraFry, familyMarket, captainMarket];

    return ServiceListingConfig(
      type: ServiceListingType.pickup,
      title: l10n.serviceListingPickupTitle,
      searchHint: l10n.serviceSearchHint,
      categories: allServiceCategories(l10n),
      filters: topFilters(l10n),
      groups: [
        ServiceListingGroupData(
          title: l10n.serviceAllPlaces,
          items: pickupItems,
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategorySupermarket,
          includeInAll: false,
          items: [familyMarket, captainMarket],
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategorySnacks,
          includeInAll: false,
          items: [rimasLand, taheraFry],
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryFastFood,
          includeInAll: false,
          items: [taheraFry],
        ),
        ServiceListingGroupData(
          title: l10n.serviceCategoryFlowers,
          includeInAll: false,
          items: [rimasLand],
        ),
      ],
    );
  }

  static List<ServiceCategoryData> _restaurantCategories(
    AppLocalizations l10n,
  ) {
    return [
      ServiceCategoryData(
        label: l10n.serviceCategoryDesserts,
        imageAsset: AppAssets.serviceRestaurantDesserts,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryGrills,
        imageAsset: AppAssets.serviceRestaurantGrills,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryPizza,
        imageAsset: AppAssets.serviceRestaurantPizza,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryFastFood,
        imageAsset: AppAssets.serviceRestaurantFastFood,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryBurger,
        imageAsset: AppAssets.serviceRestaurantBurger,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryShawarma,
        imageAsset: AppAssets.serviceRestaurantShawarma,
      ),
    ];
  }

  static List<ServiceCategoryData> _groceryCategories(AppLocalizations l10n) {
    return [
      ServiceCategoryData(
        label: l10n.serviceCategorySupermarket,
        imageAsset: AppAssets.serviceGrocerySupermarket,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategorySnacks,
        imageAsset: AppAssets.serviceGrocerySnacks,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryDairy,
        imageAsset: AppAssets.serviceGroceryDairy,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryFruitsVegetables,
        imageAsset: AppAssets.serviceGroceryFruitsVegetables,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryRoasters,
        imageAsset: AppAssets.serviceGroceryRoasters,
      ),
    ];
  }

  static List<ServiceCategoryData> _storeCategories(AppLocalizations l10n) {
    return [
      ServiceCategoryData(
        label: l10n.serviceCategoryPerfumeBeauty,
        imageAsset: AppAssets.serviceStoresBeauty,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryFlowers,
        imageAsset: AppAssets.serviceStoresFlowers,
      ),
    ];
  }

  static List<ServiceCategoryData> _pickupCategories(AppLocalizations l10n) {
    return [
      ServiceCategoryData(
        label: l10n.serviceCategorySupermarket,
        imageAsset: AppAssets.serviceGrocerySupermarket,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategorySnacks,
        imageAsset: AppAssets.serviceGrocerySnacks,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryFastFood,
        imageAsset: AppAssets.serviceRestaurantFastFood,
      ),
      ServiceCategoryData(
        label: l10n.serviceCategoryFlowers,
        imageAsset: AppAssets.serviceStoresFlowers,
      ),
    ];
  }

  static List<ServiceCategoryData> _uniqueCategories(
    List<ServiceCategoryData> categories,
  ) {
    final labels = <String>{};
    return [
      for (final category in categories)
        if (labels.add(category.label)) category,
    ];
  }

  static List<ServicePlaceData> _repeat(
    List<ServicePlaceData> items,
    int count,
  ) {
    return List.generate(count, (index) => items[index % items.length]);
  }
}

class ServiceCategoryData {
  const ServiceCategoryData({
    required this.label,
    this.imageAsset,
    this.fallbackIcon = Icons.storefront_outlined,
  });

  final String label;
  final String? imageAsset;
  final IconData fallbackIcon;
}

class ServiceFilterData {
  const ServiceFilterData({required this.id, required this.label});

  final ServiceFilterId id;
  final String label;
}

enum ServiceFilterId { offers, fastDelivery, topRated }

class ServiceListingGroupData {
  const ServiceListingGroupData({
    required this.title,
    required this.items,
    this.largeItems = const [],
    this.includeInAll = true,
  });

  final String title;
  final List<ServicePlaceData> items;
  final List<ServicePlaceData> largeItems;
  final bool includeInAll;
}

enum ServicePlaceKind { restaurant, store, pickup }

class ServicePlaceData {
  const ServicePlaceData._({
    required this.kind,
    this.id,
    required this.name,
    required this.time,
    required this.imageAsset,
    required this.rating,
    this.hasOffer = false,
    this.fastDelivery = false,
    this.topRated = true,
    this.showFavourite = false,
    this.subtitle,
    this.isMajor = false,
  });

  final String? id;

  factory ServicePlaceData.restaurant({
    String? id,
    required String name,
    required String subtitle,
    required String time,
    required String imageAsset,
    required String rating,
    bool hasOffer = false,
    bool fastDelivery = false,
    bool topRated = true,
    bool isMajor = false,
  }) {
    return ServicePlaceData._(
      kind: ServicePlaceKind.restaurant,
      id: id,
      name: name,
      subtitle: subtitle,
      time: time,
      imageAsset: imageAsset,
      rating: rating,
      hasOffer: hasOffer,
      fastDelivery: fastDelivery,
      topRated: topRated,
      isMajor: isMajor,
    );
  }

  factory ServicePlaceData.store({
    String? id,
    required String name,
    required String time,
    required String imageAsset,
    required String rating,
    bool hasOffer = false,
    bool fastDelivery = false,
    bool topRated = true,
    bool showFavourite = false,
    bool isMajor = false,
  }) {
    return ServicePlaceData._(
      kind: ServicePlaceKind.store,
      id: id,
      name: name,
      time: time,
      imageAsset: imageAsset,
      rating: rating,
      hasOffer: hasOffer,
      fastDelivery: fastDelivery,
      topRated: topRated,
      showFavourite: showFavourite,
      isMajor: isMajor,
    );
  }

  factory ServicePlaceData.pickup({
    String? id,
    required String name,
    required String time,
    required String imageAsset,
    required String rating,
    bool hasOffer = false,
    bool fastDelivery = false,
    bool topRated = true,
    bool isMajor = false,
  }) {
    return ServicePlaceData._(
      kind: ServicePlaceKind.pickup,
      id: id,
      name: name,
      time: time,
      imageAsset: imageAsset,
      rating: rating,
      hasOffer: hasOffer,
      fastDelivery: fastDelivery,
      topRated: topRated,
      isMajor: isMajor,
    );
  }

  final ServicePlaceKind kind;
  final String name;
  final String time;
  final String imageAsset;
  final String rating;
  final bool hasOffer;
  final bool fastDelivery;
  final bool topRated;
  final bool showFavourite;
  final String? subtitle;
  final bool isMajor;
}
