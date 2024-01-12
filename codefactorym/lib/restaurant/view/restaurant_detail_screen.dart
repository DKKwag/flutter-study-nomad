import 'package:codefactorym/common/layout/default_layout.dart';
import 'package:codefactorym/product/product_card.dart';
import 'package:codefactorym/restaurant/component/restaurant_card.dart';
import 'package:codefactorym/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactorym/restaurant/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  // Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
  //   return

  // restaurant_repository.dart에 만듬
  // final dio = ref.watch(dioProvider);

  //아래는 기존로직 위는 Provider를 사용한 로직
  // final dio = Dio();
  // dio.interceptors.add(
  //   CustomInterceptor(
  //     storage: storage,
  //   ),
  // );

  // restaurant_repository.dart에 만듬
  // final repository =
  //     RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  // return repository.getRestaurantDetail(id: id);

  //repository넣기전 기존 로직
  // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  // final resp = await dio.get(
  //   'http://$ip/restaurant/$id',
  //   options: Options(headers: {
  //     'authorization': 'Bearer $accessToken',
  //   }),
  // );
  // return resp.data;
  //}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(
              id: id,
            ),
        // 기존로직 future: getRestaurantDetail(ref),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //기존 로직
          // final item = RestaurantDetailModel.fromJson(
          //   snapshot.data!,
          // );
          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
