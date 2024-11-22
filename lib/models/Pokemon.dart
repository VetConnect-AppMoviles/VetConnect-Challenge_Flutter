class Pokemon {
  int? id;
  String? name;
  String? imageUrl;
  bool? isFavorite;
  int? height;
  int? weight;
  int? baseExperience;

  Pokemon(this.id, this.name, this.imageUrl, this.isFavorite, this.height, this.weight, this.baseExperience);

  Pokemon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['sprites']['front_default'];
    isFavorite = false;
    height = json['height'];
    weight = json['weight'];
    baseExperience = json['base_experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['isFavorite'] = this.isFavorite;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['baseExperience'] = this.baseExperience;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'height': height,
      'weight': weight,
      'baseExperience': baseExperience,
    };
  }
}