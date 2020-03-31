class PostItem {
  String sId;
  String slug;
  String raw;
  String categories;
  int date;
  List<String> tags;
  String layout;
  bool published;
  String title;
  String sContent;

  PostItem(
      {this.sId,
      this.slug,
      this.raw,
      this.categories,
      this.date,
      this.tags,
      this.layout,
      this.published,
      this.title,
      this.sContent});

  PostItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slug = json['slug'];
    raw = json['raw'];
    categories = json['categories'];
    date = json['date'];
    tags = json['tags']?.cast<String>();
    layout = json['layout'];
    published = json['published'];
    title = json['title'];
    sContent = json['_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['slug'] = this.slug;
    data['raw'] = this.raw;
    data['categories'] = this.categories;
    data['date'] = this.date;
    data['tags'] = this.tags;
    data['layout'] = this.layout;
    data['published'] = this.published;
    data['title'] = this.title;
    data['_content'] = this.sContent;
    return data;
  }
}