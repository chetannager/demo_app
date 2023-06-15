package com.example.demo_app;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.EventChannel;

public class SensorsInfo implements SensorEventListener, EventChannel.StreamHandler {
    private static final String sensorCHANNEL = "com.test/sensor";

    private SensorManager sensorManager;

    private  Sensor magneticSensor;

    private EventChannel.EventSink eventSink = null;

    
    SensorsInfo(EventChannel event, SensorManager sensorManager,Sensor magneticSensor){
        this.sensorManager = sensorManager;
        this.magneticSensor = magneticSensor;
        event.setStreamHandler(this);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
        if(eventSink == null)
            magneticSensor = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

        sensorManager.registerListener(this, magneticSensor, SensorManager.SENSOR_DELAY_UI);
    }

    @Override
    public void onCancel(Object arguments) {
        if(eventSink == null)
            sensorManager.unregisterListener(this);
        eventSink = null;
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if(event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD){
            List<Float> analogs = new ArrayList<Float>();
            analogs.add(event.values[0]);
            analogs.add(event.values[1]);
            analogs.add(event.values[2]);
            eventSink.success(analogs);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}
