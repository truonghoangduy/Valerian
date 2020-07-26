package com.pauldemarco.foregroundservice;

import android.annotation.SuppressLint;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import org.tensorflow.lite.Interpreter;
import org.tensorflow.lite.gpu.GpuDelegate;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Vector;

public class TensorFlowImageClassifier implements Classifier {
    private static final String TAG = "TensorFlowImageClassifier";
    private Interpreter interpreter;
    private int inputSize;
    private boolean quant;
    private static final int BATCH_SIZE = 1;
    private static final int PIXEL_SIZE = 3;
    private static final int IMAGE_MEAN = 128;
    private static final float IMAGE_STD = 128.0f;

    int MAX_RESULTS;
    float THRESHOLD;
    List<String> labelList;

    ByteBuffer modelFile;

    TensorFlowImageClassifier(
//            AssetManager assetManager,
            String modelPath,
            String labelPath,
            List<String> lableListing,
            ByteBuffer modelBytebuffer,
            int inputSize,
            boolean quant,int MAX_RESULTS,float THRESHOLD
    ){
        this.inputSize = inputSize;
        this.quant = quant;
        this.MAX_RESULTS = MAX_RESULTS;
        this.THRESHOLD = THRESHOLD;
        labelList = lableListing;
        GpuDelegate delegate = new GpuDelegate();
        Interpreter.Options options = (new Interpreter.Options()).addDelegate(delegate);
        interpreter = new Interpreter(modelBytebuffer,options);
        Log.d(TAG,"OK");
    }

//    static Classifier create(AssetManager assetManager,
//                             String modelPath,
//                             String labelPath,
//                             int inputSize,
//                             boolean quant,int MAX_RESULTS,float THRESHOLD) throws IOException {
////        GpuDelegate delegate = new GpuDelegate();
////        Interpreter.Options options = (new Interpreter.Options()).addDelegate(delegate);
//        TensorFlowImageClassifier classifier = new TensorFlowImageClassifier();
////        classifier.interpreter = new Interpreter(classifier.loadModelFile(assetManager, modelPath), new Interpreter.Options());
//
////        classifier.interpreter = new Interpreter(classifier.loadModelFile(assetManager, modelPath), options);
//        classifier.labelList = classifier.loadLabels(assetManager, labelPath);
//        classifier.inputSize = inputSize;
//        classifier.quant = quant;
//        classifier.MAX_RESULTS = MAX_RESULTS;
//        classifier.THRESHOLD = THRESHOLD;
//
//
//        return classifier;
//    }




    private ByteBuffer convertBitmapToByteBuffer(Bitmap bitmap) {
        ByteBuffer byteBuffer;

        if(quant) {
            byteBuffer = ByteBuffer.allocateDirect(BATCH_SIZE * inputSize * inputSize * PIXEL_SIZE);
        } else {
            byteBuffer = ByteBuffer.allocateDirect(4 * BATCH_SIZE * inputSize * inputSize * PIXEL_SIZE);
        }

        byteBuffer.order(ByteOrder.nativeOrder());
        int[] intValues = new int[inputSize * inputSize];
        bitmap.getPixels(intValues, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
        int pixel = 0;
        for (int i = 0; i < inputSize; ++i) {
            for (int j = 0; j < inputSize; ++j) {
                final int val = intValues[pixel++];
                if(quant){
                    byteBuffer.put((byte) ((val >> 16) & 0xFF));
                    byteBuffer.put((byte) ((val >> 8) & 0xFF));
                    byteBuffer.put((byte) (val & 0xFF));
                } else {
                    byteBuffer.putFloat((((val >> 16) & 0xFF)-IMAGE_MEAN)/IMAGE_STD);
                    byteBuffer.putFloat((((val >> 8) & 0xFF)-IMAGE_MEAN)/IMAGE_STD);
                    byteBuffer.putFloat((((val) & 0xFF)-IMAGE_MEAN)/IMAGE_STD);
                }

            }
        }
        return byteBuffer;
    }




//    private Vector<String> labels;
//    float[][] labelProb;

    public List<String> loadLabels(AssetManager assetManager, String path) {
        BufferedReader br;
        try {
            if (assetManager != null) {
                br = new BufferedReader(new InputStreamReader(assetManager.open(path)));
            } else {
                br = new BufferedReader(new InputStreamReader(new FileInputStream(new File(path))));
            }
            String line;
            List<String> label = new ArrayList<>();
            while ((line = br.readLine()) != null) {
                labelList.add(line);
            }
            Log.d(TAG,"OK when read Lable");
            br.close();
            return label;
        } catch (IOException e) {
            throw new RuntimeException("Failed to read label file", e);
        }
    }


    public Bitmap transfromBluetoothDataToBitMap(byte[] bytes){
        return BitmapFactory.decodeByteArray(bytes,0,bytes.length);
    }

    public Bitmap reScaleBitMap(Bitmap bitmap){
        return Bitmap.createScaledBitmap(bitmap,inputSize,inputSize,false);
    }



    private MappedByteBuffer loadModelFile(AssetManager assetManager, String modelPath) throws IOException {
        AssetFileDescriptor fileDescriptor = assetManager.openFd(modelPath);
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
    }



    public Bitmap handleBluetoothDataToBitMap(Bitmap bytes){

        return reScaleBitMap(bytes);
//        return reScaleBitMap(transfromBluetoothDataToBitMap(bytes));
    }

    @Override
    public List<Recognition> recognizeImage(Bitmap bitmap) {
        long startTime = System.currentTimeMillis();
        ByteBuffer byteBuffer = convertBitmapToByteBuffer(handleBluetoothDataToBitMap(bitmap));
        long totalTime = System.currentTimeMillis() - startTime;
        Log.d("Total REMADE BUFFER TIME 🏙", String.valueOf(totalTime));
        if (quant){
            byte[][] result = new byte[1][labelList.size()];
            interpreter.run(byteBuffer, result);

            return getSortedResultByte(result);
        }else {
            startTime = System.currentTimeMillis();

            float [][] result = new float[1][labelList.size()];
            interpreter.run(byteBuffer, result);
            totalTime = System.currentTimeMillis() - startTime;
            Log.d("Total REMADE BUFFER TIME 🔥", String.valueOf(totalTime));
            return getSortedResultFloat(result);
        }
    }

    @SuppressLint("DefaultLocale")
    private List<Recognition> getSortedResultByte(byte[][] labelProbArray) {

        PriorityQueue<Recognition> pq =
                new PriorityQueue<>(
                        MAX_RESULTS,
                        new Comparator<Recognition>() {
                            @Override
                            public int compare(Recognition lhs, Recognition rhs) {
                                return Float.compare(rhs.getConfidence(), lhs.getConfidence());
                            }
                        });

        for (int i = 0; i < labelList.size(); ++i) {
            float confidence = (labelProbArray[0][i] & 0xff) / 255.0f;
            if (confidence > THRESHOLD) {
                pq.add(new Recognition("" + i,
                        labelList.size() > i ? labelList.get(i) : "unknown",
                        confidence, quant));
            }
        }

        final ArrayList<Recognition> recognitions = new ArrayList<>();
        int recognitionsSize = Math.min(pq.size(), MAX_RESULTS);
        for (int i = 0; i < recognitionsSize; ++i) {
            recognitions.add(pq.poll());
        }

        return recognitions;
    }

    @SuppressLint("DefaultLocale")
    private List<Recognition> getSortedResultFloat(float[][] labelProbArray) {

        PriorityQueue<Recognition> pq =
                new PriorityQueue<>(
                        MAX_RESULTS,
                        new Comparator<Recognition>() {
                            @Override
                            public int compare(Recognition lhs, Recognition rhs) {
                                return Float.compare(rhs.getConfidence(), lhs.getConfidence());
                            }
                        });

        for (int i = 0; i < labelList.size(); ++i) {
            float confidence = labelProbArray[0][i];
            if (confidence > THRESHOLD) {
                pq.add(new Recognition("" + i,
                        labelList.size() > i ? labelList.get(i) : "unknown",
                        confidence, quant));
            }
        }

        final ArrayList<Recognition> recognitions = new ArrayList<>();
        int recognitionsSize = Math.min(pq.size(), MAX_RESULTS);
        for (int i = 0; i < recognitionsSize; ++i) {
            recognitions.add(pq.poll());
        }

        return recognitions;
    }

    @Override
    public void close() {
        interpreter.close();
        interpreter = null;
    }
}
