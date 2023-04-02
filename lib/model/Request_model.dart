List<RequestModel> productsFromJson(dynamic str) =>
    List<RequestModel>.from((str).map((x) => RequestModel.fromJson(x)));

class RequestModel {
  late int? id;
  late String? data;
  late int? id_client;
  late int qtd;
  late int? id_product;
  late String desc;

  RequestModel({
    this.id,
    this.data,
    this.id_client,
    required this.qtd,
    this.id_product,
    required this.desc,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    id_client = json['id_client'];
    qtd = json['qtd'];
    id_product = json['id_product'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['data'] = data;
    return _data;
  }
}