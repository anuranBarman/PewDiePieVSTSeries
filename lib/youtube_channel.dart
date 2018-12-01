class Channel {
  String imgUrl;
  int subCount;
  String name;

  Channel(this.name,this.imgUrl,this.subCount);

  factory Channel.fromJSON(Map<String,dynamic> map){
    print(map['items'][0]['snippet']['title']);
    return Channel(map['items'][0]['snippet']['title'],map['items'][0]['snippet']['thumbnails']['high']['url'], int.parse(map['items'][0]['statistics']['subscriberCount']));
  }
}