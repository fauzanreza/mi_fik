import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PostImageContent {
  Future<String> sendImageContent(XFile imageFile, String path) async {
    final prefs = await SharedPreferences.getInstance();
    String url;
    String seed;

    if (imageFile != null) {
      seed = const Uuid().v4();

      Reference ref = FirebaseStorage.instance.ref(path).child(seed);

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
    return url;
  }
}
