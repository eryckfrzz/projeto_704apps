class Url {
  String url = 'https://api.zafiras.com.br';

  getUri() {
    return Uri.parse(url);
  }
}
