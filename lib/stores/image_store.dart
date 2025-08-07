import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/ilist_images.dart';
import 'package:projeto_704apps/services/remote/image_vehicle_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'image_store.g.dart';

class ImageStore = _ImageStore with _$ImageStore;

abstract class _ImageStore with Store {
  @observable
  ListImages? image;

  final ImageAnalyzeDaoImpl imageAnalyzeDaoImpl = ImageAnalyzeDaoImpl();

  @action
  Future<ListImages?> registerImageAnalysis(
    int userId,
    List<String> paths,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    ListImages? newImage = await imageAnalyzeDaoImpl.registerImageAnalysis(
      userId,
      paths,
      token: token!,
    );

    if (newImage != null) {
      image = newImage;
      return newImage;
    }else{
      print('Erro ao registrar análise de imagem.');
      return null;
    }
  }
}
