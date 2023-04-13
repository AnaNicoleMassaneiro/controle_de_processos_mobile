List<RequestModel> requestsFromJson(List<dynamic> json) =>
    List<RequestModel>.from(json.map((x) => RequestModel.fromJson(x)));

class RequestModel {
  late int? id;
  late String? data;
  late int? id_client;
  late int? qtd;
  late int? id_product;
  late String? desc;
  late String? name;
  late String? sellerName;
  late String? cpf;

  RequestModel({
    this.id,
    this.data,
    this.id_client,
    required this.qtd,
    this.id_product,
    required this.desc,
    required name,
    required sellerName,
    required cpf,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    id_client = json['id_client'];
    qtd = json['qtd'];
    id_product = json['id_product'];
    desc = json['desc'];
    qtd = json['name'];
    id_product = json['sellerName'];
    desc = json['cpf'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['data'] = data;
    _data['id_client'] = id_client;
    _data['qtd'] = qtd;
    _data['id_product'] = id_product;
    _data['desc'] = desc;
    _data['name'] = qtd;
    _data['sellerName'] = id_product;
    _data['cpf'] = desc;
    return _data;
  }
}