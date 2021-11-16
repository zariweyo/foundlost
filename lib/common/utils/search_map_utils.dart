class SearchMapsUtils {
  static List<String> generateKeywords(List<String> strings){
    List<String> keywords = [];
    for (var str in strings) {
      for (var key in str.toLowerCase().split(" ")){
        while(key.length>=2){
          keywords.add(key);
          key = key.substring(0,key.length-1);
        } 
      }
    }
    return keywords;
  }
}