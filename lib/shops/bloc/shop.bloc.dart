import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/shops/model/category.model.dart';
import 'package:kushi/shops/model/post.json.cost.env.dart';
import 'package:kushi/shops/model/product.color.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/model/product.size.model.dart';
import 'package:kushi/shops/model/promotions.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/model/verify.code.dart';
import 'package:wakelock/wakelock.dart';

class ShopBloc implements Bloc {
  final _shopBlocRepository = ShopRepository();
  final _businessBlocRepository = BusinessRepository();
  Future<List<ProductModel>> fetchProductRepository(
          String idBusiness, String idUser) =>
      _shopBlocRepository.fetchProductRepository(idBusiness, idUser);
  Future<List<CategoryModel>> fetchCategoryRepository(String idBusiness) =>
      _shopBlocRepository.fetchCategoryRepository(idBusiness);
  Future<List<PromotionsModel>> fetchPromotionsRepository(String id) =>
      _shopBlocRepository.fetchPromotionsRepository(id);
  Future<List<ProductColorModel>> fetchProductColorsRepository(String id) =>
      _shopBlocRepository.fetchProductColorsRepository(id);
  Future<List<ProductSizeModel>> fetchProductSizeRepository(
          String id, String idcolor) =>
      _shopBlocRepository.fetchProductSizeRepository(id, idcolor);
  Future<List<ProductModel>> fetchWishListProductBloc(String idUser) =>
      _shopBlocRepository.fetchWishListProductRepository(idUser);
  Future<bool> saveProduductFavoriteBloc(
          String idProduct, String idUser, String idBusiness) =>
      _shopBlocRepository.saveProduductFavoriteRepository(
          idProduct, idUser, idBusiness);
  Future<bool> removeProduductFavoriteRepository(
          String idProduct, String idUser) =>
      _shopBlocRepository.removeProduductFavoriteRepository(idProduct, idUser);
  Future<List<GetProductEnStock>> getStockExistBloc(
          List<ProductModel> products) =>
      _shopBlocRepository.getStockExistRepository(products);
  Future<int> verifyShopPaymetBloc(String idClient, String idBusiness) =>
      _shopBlocRepository.verifyShopPaymet(idClient, idBusiness);
  Future<VERIFICODE> saveShopProductBloc(
          String codmediPago,
          String formapago,
          String estadoCom,
          String targetTypeOption,
          Business business,
          TimedateEnd delivery,
          UserModel user,
          PaymetProductDetail payment,
          List<ProductModel> products) =>
      _shopBlocRepository.saveShopProductRepository(
          codmediPago,
          formapago,
          estadoCom,
          targetTypeOption,
          business,
          delivery,
          user,
          payment,
          products);
  Future<MedioPago> queryMethodPaymentRepository(
          String codTarget, Business business) =>
      _shopBlocRepository.queryMethodPaymentRepository(codTarget, business);
  Future<List<TimeAttentionBusiness>> fetchTimeBusinesBloc(String idBusiness) =>
      _businessBlocRepository.fetchTimeBusinesRepository(idBusiness);
  Future<bool> wakelock() => Wakelock.isEnabled;
  Future<int> updateStatusOrderClient(String idOrder) =>
      _shopBlocRepository.updateStatusOrderClient(idOrder);

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
