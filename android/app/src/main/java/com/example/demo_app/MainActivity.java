package com.example.demo_app;

import static com.example.demo_app.KeyHelper.getFingerprint;

import android.annotation.SuppressLint;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.pm.Signature;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Bundle;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import android.os.Build;
import android.provider.Settings;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.io.Serializable;
import java.math.BigInteger;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity  {
    private static final String CHANNEL = "com.test/test";
    private static final String packageManagerCHANNEL = "com.bitinfinity/packageManager";
    private static final String sensorCHANNEL = "com.test/sensor";
    private  static  final  String developerPage = "BitInfinity Web Solutions Pvt Ltd";
    private  static  final  String developerPageId = "4964515893474475590";

    private SensorManager sensorManager;

    private  Sensor magneticSensor  = null;

    private EventChannel.EventSink eventSink = null;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());

        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);

        magneticSensor = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

        EventChannel event = new EventChannel(this.getFlutterEngine().getDartExecutor(), sensorCHANNEL);

        new SensorsInfo(event, sensorManager,magneticSensor);

        MethodChannel packageManagerChannel = new MethodChannel(this.getFlutterEngine().getDartExecutor().getBinaryMessenger(),packageManagerCHANNEL);

        //new com.example.demo_app.PackageManager(this,packageManagerChannel);


        new MethodChannel(this.getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "getInstalledList":
                            boolean systemApps = call.argument("systemApps");
                            result.success(getInstalledList(systemApps));
                            break;
                        case "getPackageDetail": {
                            String packageName = call.argument("packageName");
                            result.success(getPackageDetail(packageName));
                            break;
                        }
                        case "getPackagePermissions": {
                            String packageName = call.argument("packageName");
                            result.success(getPackagePermissions(packageName));
                            break;
                        }
                        case "isInstall": {
                            String packageName = call.argument("packageName");
                            result.success(isInstall(packageName));
                            break;
                        }
                        case "openAppSettings": {
                            String packageName = call.argument("packageName");
                            result.success(openAppSettings(packageName));
                            break;
                        }
                        case "openApp": {
                            String packageName = call.argument("packageName");
                            PackageManager packageManager = getPackageManager();
                            Intent intent = packageManager.getLaunchIntentForPackage(packageName);
                            if (intent == null) {
                                result.success(false);
                            } else {
                                startActivity(intent);
                                result.success(true);
                            }

                            break;
                        }
                        case "unInstall": {
                            String packageName = call.argument("packageName");
                            Intent intent = new Intent(Intent.ACTION_UNINSTALL_PACKAGE);
                            intent.setData(Uri.parse("package:" + packageName));
                            intent.putExtra(Intent.EXTRA_RETURN_RESULT, true);
                            startActivityForResult(intent, 1);
                            result.success(true);
                            break;
                        }

                        case "moreApps": {
                            Intent intent = new Intent(Intent.ACTION_VIEW);
                                intent.setData(Uri.parse("market://search?q=pub:"+developerPage));
                            try {
                                startActivity(intent);
                                result.success(true);
                            } catch (ActivityNotFoundException e) {
                                intent.setData(Uri.parse("https://play.google.com/store/apps/dev?id="+developerPageId));
                                Toast.makeText(this, "Could not open Android Google PlayStore, please install the Google play app.", Toast.LENGTH_SHORT).show();
                                result.success(false);
                            }
                            break;
                        }

                        case "launchReview":{
                            String appId = call.argument("packageName");

                            if (appId == null) {
                                appId = getPackageName();
                            }

                            Intent rateIntent = new Intent(Intent.ACTION_VIEW,
                                    Uri.parse("market://details?id=" + appId));
                            boolean marketFound = false;

                            // find all applications able to handle our rateIntent
                            @SuppressLint("QueryPermissionsNeeded") final List<ResolveInfo> otherApps =  getPackageManager()
                                    .queryIntentActivities(rateIntent, 0);
                            for (ResolveInfo otherApp: otherApps) {
                                // look for Google Play application
                                if (otherApp.activityInfo.applicationInfo.packageName
                                        .equals("com.android.vending")) {

                                    ActivityInfo otherAppActivity = otherApp.activityInfo;
                                    ComponentName componentName = new ComponentName(
                                            otherAppActivity.applicationInfo.packageName,
                                            otherAppActivity.name
                                    );
                                    // make sure it does NOT open in the stack of your activity
                                    rateIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    // task reparenting if needed
                                    rateIntent.addFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
                                    // if the Google Play was already open in a search result
                                    //  this make sure it still go to the app page you requested
                                    rateIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                                    // this make sure only the Google Play app is allowed to
                                    // intercept the intent
                                    rateIntent.setComponent(componentName);
                                    Toast.makeText(getActivity(), "Please Rate Application", Toast.LENGTH_SHORT).show();

                                    startActivity(rateIntent);
                                    marketFound = true;
                                    break;

                                }
                            }

                            // if GP not present on device, open web browser
                            if (!marketFound) {
                                try {
                                    startActivity(new Intent(Intent.ACTION_VIEW,
                                            Uri.parse("market://details?id=" + appId)));
                                } catch (ActivityNotFoundException e) {
                                    startActivity(new Intent(Intent.ACTION_VIEW,
                                            Uri.parse("https://play.google.com/store/apps/details?id=" + appId)));
                                }
                            }
                            result.success(null);
                            break;
                        }

                        case "batteryLevel" : {
                            result.success(getBatteryLevel());
                            break;
                        }

                        case "share" : {
                            String text = call.argument("text");
                            String subject = call.argument("subject");
                            share(text,subject);
                            result.success(true);
                            break;
                        }

                        case "toast" : {
                            String text = call.argument("text");
                            Toast.makeText(getActivity(), text, Toast.LENGTH_SHORT).show();
                            result.success(true);
                            break;
                        }

                        default:
                            result.notImplemented();
                            break;
                    }
                }
        );
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1) {
            if (resultCode == RESULT_OK) {
                Log.d("TAG", "onActivityResult: user accepted the (un)install");
            } else if (resultCode == RESULT_CANCELED) {
                Log.d("TAG", "onActivityResult: user canceled the (un)install");
            } else if (resultCode == RESULT_FIRST_USER) {
                Log.d("TAG", "onActivityResult: failed to (un)install");
            }
        }
    }

    private List<Map<String, Serializable>> getInstalledList(boolean systemApps){
        Log.d("applist","Start");
        List<Map<String, Serializable>> list = new ArrayList<>();
        final PackageManager packageManager = getPackageManager();
         List<PackageInfo> packages = packageManager.getInstalledPackages(0);
        for(int i=0; i<packages.size(); i++) {
            PackageInfo packageInfo = packages.get(i);
            if(systemApps){
                    Map<String, Serializable> info = new HashMap<>();
                    info.put("packageName", packageInfo.packageName);
                    info.put("appName", packageInfo.applicationInfo.loadLabel(getPackageManager()).toString());

                    byte[] appIconBytes = new byte[0];
                    try {
                        Drawable appIcon = packageManager.getApplicationIcon(packageInfo.packageName);
                        final Bitmap bmp = Bitmap.createBitmap(appIcon.getIntrinsicWidth(), appIcon.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
                        final Canvas canvas = new Canvas(bmp);
                        appIcon.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
                        appIcon.draw(canvas);

                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        bmp.compress(Bitmap.CompressFormat.PNG, 100, baos);
                        appIconBytes = baos.toByteArray();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    info.put("appIcon", appIconBytes);

                    list.add(info);
            }else{
                if((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM)==0) {
                    Map<String, Serializable> info = new HashMap<>();
                    info.put("packageName", packageInfo.packageName);
                    info.put("appName", packageInfo.applicationInfo.loadLabel(getPackageManager()).toString());

                    byte[] appIconBytes = new byte[0];
                    try {
                        Drawable appIcon = packageManager.getApplicationIcon(packageInfo.packageName);
                        final Bitmap bmp = Bitmap.createBitmap(appIcon.getIntrinsicWidth(), appIcon.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
                        final Canvas canvas = new Canvas(bmp);
                        appIcon.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
                        appIcon.draw(canvas);

                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        bmp.compress(Bitmap.CompressFormat.PNG, 100, baos);
                        appIconBytes = baos.toByteArray();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    info.put("appIcon", appIconBytes);

                    list.add(info);
                }
            }
        }
        Log.d("applist","End");
        return list;
    }

    private Map<String, Serializable> getPackageDetail(String packageName){
        Log.d("packageDetails","Start");
        Map<String, Serializable> info = new HashMap<>();

        final PackageManager packageManager = getPackageManager();
        PackageInfo packageInfo;
        try {
            packageInfo = packageManager.getPackageInfo(packageName, 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }

        info.put("packageName", (String)packageInfo.packageName);
        info.put("appName", (String)packageInfo.applicationInfo.loadLabel(getPackageManager()).toString());
        info.put("versionName", (String)packageInfo.versionName);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            info.put("versionCode", (int) packageInfo.getLongVersionCode());
        } else {
            info.put("versionCode", (int) packageInfo.versionCode);
        }
        String pattern = "dd-MM-yyyy";
        @SuppressLint("SimpleDateFormat") SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        info.put("firstInstallTime", (String)simpleDateFormat.format( packageInfo.firstInstallTime));
        info.put("lastUpdateTime", (String)simpleDateFormat.format(packageInfo.lastUpdateTime));

        int targetSdkVersion;
        int minSdkVersion= 0;

        try {
            ApplicationInfo applicationInfo = packageManager.getApplicationInfo(packageName, 0);
            if (applicationInfo != null) {
                targetSdkVersion= applicationInfo.targetSdkVersion;
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    minSdkVersion= applicationInfo.minSdkVersion;
                }

                info.put("targetSdkVersion", (Serializable) targetSdkVersion);
                info.put("minSdkVersion", (Serializable) minSdkVersion);
            }
            info.put("installedBy",(String)getPackageManager().getInstallerPackageName(packageName));
            info.put("gids",(Serializable) packageInfo.gids);
            info.put("sharedUserId",(String)packageInfo.sharedUserId);



            assert applicationInfo != null;
            info.put("uid",(Serializable) applicationInfo.uid);
            info.put("processName",(String)applicationInfo.processName);
            info.put("publicSourceDir", (String)applicationInfo.publicSourceDir);
            info.put("dataDir", (String)applicationInfo.dataDir);
            info.put("nativeLibraryDir", (String)applicationInfo.nativeLibraryDir);
            info.put("sourceDir", (String)applicationInfo.sourceDir);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                info.put("deviceProtectedDataDir", (String)applicationInfo.deviceProtectedDataDir);
            }
            info.put("apkMD5",(String)Util.getAPKMD5(this,applicationInfo.sourceDir));

            String[] sharedLibraryFiles=applicationInfo.sharedLibraryFiles;
            if(sharedLibraryFiles==null){
                info.put("sharedLibraryFiles", null);
            }else{
                info.put("sharedLibraryFiles", null);
                List<String> _sharedLibraryFiles= new ArrayList<>();
                _sharedLibraryFiles= Arrays.asList(sharedLibraryFiles);
                info.put("sharedLibraryFiles", (Serializable) _sharedLibraryFiles);
                Log.d("sharedLibraryFiles", Arrays.toString(sharedLibraryFiles));
            }


        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }


//        try {
//
//            PackageInfo _info = getPackageManager().getPackageInfo(
//                    packageName, PackageManager.GET_SIGNATURES);
//
//            for (Signature signature : _info.signatures) {
//                MessageDigest md;
//                md = MessageDigest.getInstance("SHA");
//                md.update(signature.toByteArray());
//                String hash_key = new String(Base64.encode(md.digest(), 0));
//                Log.d("hash_key",hash_key);
//            }
//
//        } catch (PackageManager.NameNotFoundException e1) {
//        } catch (NoSuchAlgorithmException e) {
//        } catch (Exception e) {
//        }

        info.put("signatureMD5",getFingerprint(this, "MD5"));
        info.put("signatureSHA1",getFingerprint(this, "SHA1"));
        info.put("signatureSHA256",getFingerprint(this, "SHA256"));




        HashMap<String, Serializable> signatures = new HashMap<>();

        try {
            final List<PackageInfo> packageList = getPackageManager().getInstalledPackages(PackageManager.GET_SIGNATURES);

            for (PackageInfo p : packageList) {

                if(p.packageName.equals(packageName)) {

                    final Signature[] arrSignatures = p.signatures;
                    for (final Signature sig : arrSignatures) {
                        /*
                         * Get the X.509 certificate.
                         */
                        final byte[] rawCert = sig.toByteArray();
                        InputStream certStream = new ByteArrayInputStream(rawCert);

                        try {
                            CertificateFactory certFactory = CertificateFactory.getInstance("X509");
                            X509Certificate x509Cert = (X509Certificate) certFactory.generateCertificate(certStream);

                            signatures.put("subject", String.valueOf(x509Cert.getSubjectX500Principal()));
                            signatures.put("issuer", String.valueOf(x509Cert.getIssuerX500Principal()));
                            signatures.put("before", x509Cert.getNotBefore().toString());
                            signatures.put("after", x509Cert.getNotAfter().toString());
                            signatures.put("algname", x509Cert.getSigAlgName());
                            signatures.put("sigalgoid", x509Cert.getSigAlgOID());
                            signatures.put("version", x509Cert.getVersion());
                            signatures.put("serial", x509Cert.getSerialNumber().toString());
                            signatures.put("publickey", x509Cert.getPublicKey().toString());
                            signatures.put("signature", new BigInteger(x509Cert.getSignature()).toString(16));
                            signatures.put("type", x509Cert.getType());
                        }
                        catch (CertificateException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        info.put("signatures", signatures);
//
//        /*
//         *Activites
//         */
//
//        List<Map> activities= new ArrayList<>();
//
//        try {
//            ActivityInfo[] allactivities = packageManager.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES).activities;
//            if (allactivities != null) {
//                for (ActivityInfo activity : allactivities) {
//                    Map activityMap = new HashMap();
//                    activityMap.put("name", activity.name);
//                    activityMap.put("taskAffinity", activity.taskAffinity);
//                    activities.add(activityMap);
//                    Log.d("PACKAGE", "activity: " + activity.name);
//                    Log.d("PACKAGE", "activity: " + activity.taskAffinity);
//                }
//            }
//        }
//        catch ( PackageManager.NameNotFoundException e ) {
//            e.printStackTrace();
//        }
//        info.put("activities", (Serializable) activities);
//
//        /*
//         *Providers
//         */
//
//        List<Map> providers= new ArrayList<>();
//        try {
//            ProviderInfo[] allproviders = packageManager.getPackageInfo(packageName, PackageManager.GET_PROVIDERS).providers;
//            if (allproviders != null) {
//                for (ProviderInfo provider : allproviders) {
//                    Map providerMap = new HashMap();
//                    providerMap.put("authority", provider.authority);
//                    providerMap.put("name", provider.name);
//                    providerMap.put("processName", provider.processName);
//                    providers.add(providerMap);
//                    Log.d("PACKAGE", "provider: " + provider.authority);
//                    Log.d("PACKAGE", "provider: " + provider.name);
//                    Log.d("PACKAGE", "provider: " + provider.processName);
//                }
//            }
//        }
//        catch ( PackageManager.NameNotFoundException e ) {
//            e.printStackTrace();
//        }
//        info.put("providers", (Serializable) providers);
//
//        /*
//         *Permissions
//         */
//
//        List<String> permissions =  new ArrayList<>();
//        try {
//            String[] requestedPermissions = packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS).requestedPermissions;
//            if(requestedPermissions!=null)
//                for (String requestedPermission : requestedPermissions) {
//                    Log.d("permission list", requestedPermission);
//                }
//            permissions = Arrays.asList(requestedPermissions);
//        }
//        catch ( PackageManager.NameNotFoundException e ) {
//            e.printStackTrace();
//        }
//        info.put("permissions", (Serializable) permissions);
//
//
//        /*
//         *Permissions
//         */
//
//        List<Map> receivers =  new ArrayList<>();
//        try {
//            ActivityInfo[] allreceivers = packageManager.getPackageInfo(packageName, PackageManager.GET_RECEIVERS).receivers;
//            if(allreceivers!=null)
//                for (ActivityInfo receiver : allreceivers) {
//                    Map receiverMap = new HashMap();
//                    receiverMap.put("name", receiver.name);
//                    receiverMap.put("processName", receiver.processName);
//                    receivers.add(receiverMap);
//                    Log.d("PACKAGE", "receiver: " + receiver.name);
//                    Log.d("PACKAGE", "receiver: " + receiver.processName);
//                }
//        }
//        catch ( PackageManager.NameNotFoundException e ) {
//            e.printStackTrace();
//        }
//        info.put("receivers", (Serializable) receivers);
//
//        /*
//         *Services
//         */
//
//        List<Map> services =  new ArrayList<>();
//        try {
//            ServiceInfo[] allservices = packageManager.getPackageInfo(packageName, PackageManager.GET_SERVICES).services;
//            if(allservices!=null)
//                for (ServiceInfo service : allservices) {
//                    Map serviceMap = new HashMap();
//                    serviceMap.put("name", service.name);
//                    serviceMap.put("processName", service.processName);
//                    services.add(serviceMap);
//                    Log.d("PACKAGE", "service: " + service.name);
//                    Log.d("PACKAGE", "service: " + service.processName);
//                }
//        }
//        catch ( PackageManager.NameNotFoundException e ) {
//            e.printStackTrace();
//        }
//        info.put("services", (Serializable) services);

        byte[] appIconBytes = new byte[0];
        try {
            Drawable appIcon = packageManager.getApplicationIcon(packageName);
            final Bitmap bmp = Bitmap.createBitmap(appIcon.getIntrinsicWidth(), appIcon.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
            final Canvas canvas = new Canvas(bmp);
            appIcon.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
            appIcon.draw(canvas);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            bmp.compress(Bitmap.CompressFormat.PNG, 100, baos);
            appIconBytes = baos.toByteArray();
            } catch (Exception e) {
            e.printStackTrace();
        }
        info.put("appIcon", appIconBytes);

        info.put("appSize", (int) new File(packageInfo.applicationInfo.publicSourceDir).length());

        if((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM)==0) {
            info.put("isSystemApp", false);
        }else{
            info.put("isSystemApp", true);
        }

        boolean isDebuggable =  ( 0 != ( packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_DEBUGGABLE ) );
        info.put("isDebuggable",isDebuggable);

//        try{
//            ApplicationInfo _applicationInfo = getPackageManager().getApplicationInfo(packageName,PackageManager.GET_META_DATA);
//            Bundle _metaData = _applicationInfo.metaData;
//            Log.d("PACKAGE", "metaData: " + _metaData);
//            info.put("metaData", _metaData.toString());
//        }catch (PackageManager.NameNotFoundException e){
//            e.printStackTrace();
//        }
        Log.d("packageDetails","End");
        return info;
    }

    private  List<String> getPackagePermissions(String packageName){
        String[] requestedPermissions;
        try {
            final PackageManager packageManager = getPackageManager();
             requestedPermissions= packageManager.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS).requestedPermissions;
            if(requestedPermissions!=null)
                for (String requestedPermission : requestedPermissions) {
                    Log.d("permission list", requestedPermission);
                }

            assert requestedPermissions != null;
            return Arrays.asList(requestedPermissions);
        }
        catch ( PackageManager.NameNotFoundException e ) {
            e.printStackTrace();
            return null;
        }
    }

    private boolean openAppSettings(String packageName) {
        Intent appSettingsIntent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        appSettingsIntent.setData(Uri.parse("package:" + packageName));
        appSettingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        if (getPackageManager().queryIntentActivities(appSettingsIntent, 0).size() > 0) {
            startActivity(appSettingsIntent);
            Toast.makeText(this,"true: "+packageName.toString(),Toast.LENGTH_LONG).show();
            return true;
        }

        Toast.makeText(this,"false: "+packageName.toString(),Toast.LENGTH_LONG).show();
        return false;
    }


    private boolean isInstall(String packageName){
        final PackageManager packageManager = getPackageManager();
        List<PackageInfo> packages = packageManager.getInstalledPackages(0);
        for(int i=0; i<packages.size(); i++) {
            PackageInfo packageInfo = packages.get(i);
            if(packageInfo.packageName.equals(packageName)){
                return true;
            }
        }
        return false;
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager =
                    null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            }
            assert batteryManager != null;
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent =
                    new ContextWrapper(getApplicationContext())
                            .registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel =
                    (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100)
                            / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
        Toast.makeText(getActivity(), "Battery Level"+batteryLevel, Toast.LENGTH_SHORT).show();
        return batteryLevel;
    }

    private void share(String text, String subject) {
        if (text == null || text.isEmpty()) {
            throw new IllegalArgumentException("Non-empty text expected");
        }

        Intent shareIntent = new Intent();
        shareIntent.setAction(Intent.ACTION_SEND);
        shareIntent.putExtra(Intent.EXTRA_TEXT, text);
        shareIntent.putExtra(Intent.EXTRA_SUBJECT, subject);
        shareIntent.setType("text/plain");
        Intent chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */);
        startActivity(chooserIntent);
    }
    


}