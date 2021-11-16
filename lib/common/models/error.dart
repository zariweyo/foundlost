class GenericError{
  String code;
  String message;
  Type origin;

  GenericError({
    this.code="0000",
    this.message="NO MESSAGE",
    this.origin=GenericError
  });

  @override
  String toString() {
    String _dev = "";
    _dev += "[CODE: "+code+"]";
    _dev += "[MESSAGE: "+message+"]";
    _dev += "[ORIGIN: "+origin.toString()+"]";
    return _dev;
  }

}