List<RequestModel> productsFromJson(dynamic str) =>
    List<RequestModel>.from((str).map((x) => RequestModel.fromJson(x)));

class RequestModel {
  late int? id;
  late String? descricao;

  RequestModel({
    this.id,
    this.descricao
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
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