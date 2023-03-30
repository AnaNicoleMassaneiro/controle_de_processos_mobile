List<ClientsModel> clientsFromJson(dynamic str) =>
    List<ClientsModel>.from((str).map((x) => ClientsModel.fromJson(x)));

class ClientsModel {
  late int? id;
  late String? cpf;
  late String? name;
  late String? sobrenome;

  ClientsModel({
    this.id,
    this.cpf,
    this.name,
    this.sobrenome
  });

  ClientsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cpf = json['cpf'];
    name = json['name'];
    sobrenome = json['sobrenome'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['cpf'] = cpf;
    _data['name'] = name;
    _data['sobrenome'] = sobrenome;
    return _data;
  }
}