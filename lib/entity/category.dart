class Category {
  String id;
  String name;
  String slug;
  String path;
  String permalink;

  Category({
    this.id,
    this.name,
    this.slug,
    this.path,
    this.permalink,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    slug = json['slug'];
    path = json['path'];
    permalink = json['permalink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['path'] = this.path;
    data['permalink'] = this.permalink;
    return data;
  }
}
