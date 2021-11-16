import 'package:flutter/material.dart';

/// Widget to show loading image
class MLoading extends StatelessWidget {
  final bool enabled;
  final Color color;

  const MLoading({Key? key, this.enabled=true, this.color = Colors.black}) : super(key: key);

  Widget _showCircularProgress(){
    if (enabled) {
      return Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ));
    } 
    return const SizedBox(height: 0.0, width: 0.0,);
  }

  @override
  Widget build(BuildContext context) {
    return _showCircularProgress();
    
  }
}
