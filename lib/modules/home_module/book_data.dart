class BookModel {
  int id = 0;
  String title = "no title";
  String img = "no image";
  String date = "";
  double price = 0;
  double rate = 0;
  String shop = "no shop";

  BookModel(
      {this.id = 0,
      this.title = "no title",
      this.img = "no image",
      this.date ="08-08-2024",
      this.price = 0,
      this.rate = 0,
      this.shop = "no shop"});
}

List<BookModel> bookModelList = [
  BookModel(
    id: 1,
    title: "Train Your Mind for Extraordinary Performance and the Best",
    img: "https://images-na.ssl-images-amazon.com/images/I/61azTLgsSwL._AC_UL254_SR254,254_.jpg",
    date: "08-08-2024",
    price: 4,
    rate: 4.2,
  
  ),
  BookModel(
    id: 1,
    title: "Hope",
    img:
        "https://m.media-amazon.com/images/I/71nkuDAEd1L._SY466_.jpg",
    date: "08-08-2024",
    price: 3.5,
    rate: 3.7,
 
  ),
  BookModel(
    id: 1,
    title:
        "Essays on Friendship",
    img: "https://m.media-amazon.com/images/I/51P9TfSERuL._SY445_SX342_.jpg",
    date: "08-08-2024",
    price: 7.5,
    rate: 4.7,

  ),
   BookModel(
    id: 1,
    title: "The Psychology of Money",
    img: "https://images-na.ssl-images-amazon.com/images/I/811Q+Ij6h0L._AC_UL254_SR254,254_.jpg",
    date: "08-08-2024",
    price: 4,
    rate: 4.2,

  ),
  BookModel(
    id: 1,
    title: "Don't Believe Everything You Think",
    img:
        "https://images-na.ssl-images-amazon.com/images/I/819I+YyuU-L._AC_UL210_SR195,210_.jpg",
    date: "08-08-2024",
    price: 3.5,
    rate: 3.7,

  ),
  BookModel(
    id: 1,
    title:
        "The Let Them Theory",
    img: "https://images-na.ssl-images-amazon.com/images/I/91I1KDnK1kL._AC_UL210_SR195,210_.jpg",
    date: "08-08-2024",
    price: 7.5,
    rate: 4.7,

  ),
];
