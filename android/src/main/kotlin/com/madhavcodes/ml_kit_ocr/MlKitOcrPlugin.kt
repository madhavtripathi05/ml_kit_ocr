package com.madhavcodes.ml_kit_ocr

import android.graphics.Point
import android.graphics.Rect
import androidx.annotation.NonNull

import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.ArrayList
import java.util.HashMap
import android.content.Context


/** MlKitOcrPlugin */
class MlKitOcrPlugin : FlutterPlugin {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ml_kit_ocr")
        channel.setMethodCallHandler(TextDetector(
                flutterPluginBinding.applicationContext
        ))
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}


class TextDetector(private var context: Context) : MethodCallHandler {
    private var textRecognizer: TextRecognizer? = null

    private fun handleDetection(call: MethodCall, result: Result) {
        val imageData = call.argument<Map<String, Any>>("imageData")!!
        val inputImage: InputImage = InputImageConverter.getInputImageFromData(imageData, context, result)
                ?: return

        textRecognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)

        textRecognizer!!.process(inputImage)
                .addOnSuccessListener { text ->
                    val textResult: MutableMap<String, Any> = HashMap()
                    textResult["text"] = text.text
                    val textBlocks: MutableList<Map<String, Any>> = ArrayList()
                    for (block in text.textBlocks) {
                        val blockData: MutableMap<String, Any> = HashMap()
                        addData(blockData,
                                block.text,
                                block.boundingBox,
                                block.cornerPoints,
                                block.recognizedLanguage)
                        val textLines: MutableList<Map<String, Any>> = ArrayList()
                        for (line in block.lines) {
                            val lineData: MutableMap<String, Any> = HashMap()
                            addData(lineData,
                                    line.text,
                                    line.boundingBox,
                                    line.cornerPoints,
                                    line.recognizedLanguage)
                            val elementsData: MutableList<Map<String, Any>> = ArrayList()
                            for (element in line.elements) {
                                val elementData: MutableMap<String, Any> = HashMap()
                                addData(elementData,
                                        element.text,
                                        element.boundingBox,
                                        element.cornerPoints,
                                        element.recognizedLanguage)
                                elementsData.add(elementData)
                            }
                            lineData["elements"] = elementsData
                            textLines.add(lineData)
                        }
                        blockData["lines"] = textLines
                        textBlocks.add(blockData)
                    }
                    textResult["blocks"] = textBlocks
                    result.success(textResult)
                }
                .addOnFailureListener { e -> result.error("TextDetectorError", e.toString(), null) }
    }

    private fun addData(addTo: MutableMap<String, Any>,
                        text: String,
                        rect: Rect?,
                        cornerPoints: Array<Point>?,
                        recognizedLanguage: String) {
        val recognizedLanguages: MutableList<String> = ArrayList()
        recognizedLanguages.add(recognizedLanguage)
        val points: MutableList<Map<String, Int>> = ArrayList()
        addPoints(cornerPoints, points)
        addTo["points"] = points
        addTo["rect"] = getBoundingPoints(rect)
        addTo["recognizedLanguages"] = recognizedLanguages
        addTo["text"] = text
    }

    private fun addPoints(cornerPoints: Array<Point>?, points: MutableList<Map<String, Int>>) {
        for (point in cornerPoints!!) {
            val p: MutableMap<String, Int> = HashMap()
            p["x"] = point.x
            p["y"] = point.y
            points.add(p)
        }
    }

    private fun getBoundingPoints(rect: Rect?): Map<String, Int> {
        val frame: MutableMap<String, Int> = HashMap()
        frame["left"] = rect!!.left
        frame["right"] = rect.right
        frame["top"] = rect.top
        frame["bottom"] = rect.bottom
        return frame
    }

    private fun closeDetector() {
        textRecognizer?.close()
        textRecognizer = null
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "processImage" -> {
                handleDetection(call, result)
            }
            "closeDetector" -> {
                closeDetector()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

}
