import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostImage {
  Future<String> sendImageUser(XFile imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id_key');
    String url;
    String seed;

    if (imageFile != null) {
      seed = getRandomString(20);

      Reference ref =
          FirebaseStorage.instance.ref('profile_image').child("$id-$seed");

      final metadata = SettableMetadata(
        //contentType: 'image',
        customMetadata: {'picked-file-path': imageFile.path},
      );

      //return await ref.putData(await imageFile.readAsBytes(), metadata);
      await ref.putData(await imageFile.readAsBytes(), metadata);

      url = await ref.getDownloadURL();
    } else {
      url = null;
    }
    await prefs.setString('image_key', url.toString());

    return url;
  }
}
