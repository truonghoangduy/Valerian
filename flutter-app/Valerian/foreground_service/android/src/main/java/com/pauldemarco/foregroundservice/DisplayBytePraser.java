package com.pauldemarco.foregroundservice;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PushbackInputStream;
import java.util.ArrayList;
import java.util.List;

import me.aflak.bluetooth.reader.SocketReader;

public class DisplayBytePraser extends SocketReader  {
        private static byte JPEG_END_FLAG = -39;
        private PushbackInputStream reader;
        private byte delimiter;

        public DisplayBytePraser(InputStream inputStream) {
            super(inputStream);
            reader = new PushbackInputStream(inputStream);
            delimiter = JPEG_END_FLAG; // JPEG END FLAG
        }

    @Override
    public byte[] read() throws IOException {
        List<Byte> byteList = new ArrayList<>();
        byte[] tmp = new byte[1];
        while(true) {
            int n = reader.read();
            reader.unread(n);

            int count = reader.read(tmp);
            if(count > 0) {
                if(tmp[0] == delimiter){
                    byteList.add(tmp[0]);
                    byte[] returnBytes = new byte[byteList.size()];
                    for(int i=0 ; i<byteList.size() ; i++){
                        returnBytes[i] = byteList.get(i);
                    }
                    return returnBytes;
                } else {
                    byteList.add(tmp[0]);
                }
            }
        }
    }

}
