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
    img: "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*mp7dOjrL0JcAW9XHyjK83Q.png",
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
    img: "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*72UT4blLkx5ibjscjCo4NA.png",
    date: "08-08-2024",
    price: 7.5,
    rate: 4.7,

  ),
   BookModel(
    id: 1,
    title: "The Psychology of Money",
    img: "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*SmqZxiMcp3d_goUSmGCP-Q.png",
    date: "08-08-2024",
    price: 4,
    rate: 4.2,

  ),
  BookModel(
    id: 1,
    title: "Don't Believe Everything You Think",
    img:
        "https://miro.medium.com/v2/resize:fit:1400/format:webp/1*en61YjDmg2vmO8bpNZjUGw.png",
    date: "08-08-2024",
    price: 3.5,
    rate: 3.7,

  ),
  BookModel(
    id: 1,
    title:
        "The Let Them Theory",
    img: "https://miro.medium.com/v2/resize:fit:1286/format:webp/1*NI8lEPt0PCJjaDhcdxZ8Ow.png",
    date: "08-08-2024",
    price: 7.5,
    rate: 4.7,

  ),
];
