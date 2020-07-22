package com.pauldemarco.foregroundservice;
import me.aflak.bluetooth.Bluetooth;
import me.aflak.bluetooth.interfaces.BluetoothCallback;
import me.aflak.bluetooth.interfaces.DeviceCallback;
import me.aflak.bluetooth.interfaces.DiscoveryCallback;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Context;

public class BluetoothFetch {
    Bluetooth mBluetooth; // Main bluetooth scaning stuff

    BluetoothDevice displayDevice;
    BluetoothDevice sightDevice;


    BluetoothFetch(Context _context){
        mBluetooth = new Bluetooth(_context);
    }


}
