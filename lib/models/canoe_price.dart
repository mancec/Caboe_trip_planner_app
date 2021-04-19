class CanoePrice {
  String type;
  double price;

  // CanoePrice({this.type, this.price, this.seats});

  CanoePrice() {
    type = 'Vienvietė';
    price = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}
