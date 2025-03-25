import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class EmotionClassifier {
  Interpreter? _interpreter;
  static const int inputSize = 48;
  static const List<String> emotions = [
    'angry',
    'disgust',
    'happy',
    'neutral',
    'sad'
  ];

  // Load the TFLite model
  Future<void> loadModel() async {
    final options = InterpreterOptions();
    _interpreter = await Interpreter.fromAsset(
      'assets/models/emotion_model.tflite',
      options: options,
    );
  }

  // Preprocess image
  Float32List preprocessImage(File imageFile) {
    try {
      final bytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image to match input size
      final resizedImage =
          img.copyResize(image, width: inputSize, height: inputSize);

      // Convert to grayscale properly
      final grayscaleImage = img.grayscale(resizedImage);

      // Normalize the image to [-1, 1] range
      final inputBuffer = Float32List(inputSize * inputSize);
      int pixelIndex = 0;

      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final pixel = grayscaleImage.getPixel(x, y);
          final r = img.getRed(pixel);
          final g = img.getGreen(pixel);
          final b = img.getBlue(pixel);
          final luminance = (0.2989 * r + 0.5870 * g + 0.1140 * b) / 255.0;
          final normalizedLuminance = luminance * 2.0 - 1.0;
          inputBuffer[pixelIndex++] = normalizedLuminance;
        }
      }

      return inputBuffer;
    } catch (e) {
      print('Error preprocessing image: $e');
      rethrow;
    }
  }

  // Run inference
  Future<String> classifyImage(File imageFile) async {
    if (_interpreter == null) {
      throw Exception('Model not loaded');
    }

    try {
      final input = preprocessImage(imageFile);

      // Reshape input to match model's expected input shape
      final inputShape = [1, inputSize, inputSize, 1];
      final reshapedInput = Float32List(1 * inputSize * inputSize);
      for (int i = 0; i < input.length; i++) {
        reshapedInput[i] = input[i];
      }

      // Output buffer
      final outputBuffer =
          List.filled(emotions.length, 0.0).reshape([1, emotions.length]);

      // Run inference
      _interpreter!.run(reshapedInput.reshape(inputShape), outputBuffer);

      print("Raw predictions: ${outputBuffer[0]}");

      // Get max probability
      final List<double> resultList = outputBuffer[0];
      final maxIndex = resultList
          .indexWhere((e) => e == resultList.reduce((a, b) => a > b ? a : b));

      final confidence = resultList[maxIndex];
      if (confidence < 0.4) {
        print("Low confidence: $confidence, prediction might be incorrect.");
        throw Exception('Confidence too low for reliable prediction.');
      }

      print(
          "Predicted emotion: ${emotions[maxIndex]} with confidence: $confidence");
      return emotions[maxIndex];
    } catch (e) {
      print('Error during classification: $e');
      rethrow;
    }
  }
}
