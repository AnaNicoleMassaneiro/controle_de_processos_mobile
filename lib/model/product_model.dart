List<ProductModel> productsFromJson(dynamic str) =>
    List<ProductModel>.from((str).map((x) => ProductModel.fromJson(x)));

class ProductModel {
  late int? id;
  late String? descricao;

  ProductModel({
    this.id,
    this.descricao
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['descricao'] = descricao;
    return _data;
  }
}