import 'package:json_annotation/json_annotation.dart';
part 'post.json.get.stock.product.dart';

class ProductCod {
  String codProduct;
  ProductCod(this.codProduct);
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["Cod_Prod"] = codProduct;
    return map;
  }
}

class CuponEnv {
  String cupon;
  CuponEnv({this.cupon});
}

class ProductEnStock {
  String codProduct;
  String codColor;
  String codTalla;
  String cantidad;
  ProductEnStock({this.codProduct, this.codColor, this.codTalla, this.cantidad});
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["Cod_Prod"] = codProduct;
    map["Pco_Codigo"] = codColor;
    map["Tpr_Codigo"] = codTalla;
    map["Cantidad"] = cantidad;
    return map;
  }
}

@JsonSerializable()
class GetProductEnStock {
  String codProduct;
  int codColor;
  int codTalla;
  String disponible;
  GetProductEnStock({this.codProduct, this.codColor, this.codTalla, this.disponible});
 factory GetProductEnStock.formJson(Map<String, dynamic> json) =>
      _$GetProductEnStockFromJson(json);
  Map<String, dynamic> toJson() => _$GetProductEnStockToJson(this);
}


