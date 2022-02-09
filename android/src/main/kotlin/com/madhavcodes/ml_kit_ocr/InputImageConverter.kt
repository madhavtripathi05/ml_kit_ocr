package com.madhavcodes.ml_kit_ocr

import android.content.Context
import android.net.Uri
import android.util.Log
import com.google.mlkit.vision.common.InputImage
import io.flutter.plugin.common.MethodChannel
import java.io.File

object InputImageConverter {
    //Returns an [InputImage] from the image data received
    fun getInputImageFromData(imageData: Map<String, Any?>, context: Context, result: MethodChannel.Result): InputImage? {

        //Differentiates whether the image data is a path for a image file or contains image data in form of bytes
        val model = imageData["type"] as String?
        val inputImage: InputImage
        return when (model) {
            "file" -> {
                try {
                    inputImage = InputImage.fromFilePath(context, Uri.fromFile(File(imageData["path"] as String)))
                    inputImage
                } catch (e: Exception) {
                    Log.e("ImageError", "Getting Image failed")
                    e.printStackTrace()
                    result.error("InputImageConverterError", e.toString(), null)
                    null
                }
            }
            "bytes" -> {
                try {

                    val metaData = imageData["metadata"] as Map<*, *>?
                    inputImage = InputImage.fromByteArray((imageData["bytes"] as ByteArray?)!!,
                            (metaData!!["width"] as Double).toInt(),
                            (metaData["height"] as Double).toInt(),
                            metaData["rotation"] as Int,
                            metaData["imageFormat"] as Int
                    )
                    inputImage
                } catch (e: Exception) {
                    Log.e("ImageError", "Getting Image failed")
                    e.printStackTrace()
                    result.error("InputImageConverterError", e.toString(), null)
                    null
                }
            }
            else -> {
                result.error("InputImageConverterError", "Invalid Input Image", null)
                null
            }
        }
    }


}