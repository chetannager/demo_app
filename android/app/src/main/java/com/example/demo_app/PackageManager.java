package com.example.demo_app;

import android.content.ContextWrapper;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.Base64;

import java.io.ByteArrayOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class PackageManager {
    private final ContextWrapper contextWrapper;

    public PackageManager(ContextWrapper contextWrapper, MethodChannel channel) {
        this.contextWrapper = contextWrapper;
        channel.setMethodCallHandler((call,result)->{
            if ("getInstalledPackages".equals(call.method)) {
                boolean systemApp = call.argument("systemApp");
                result.success(getInstalledList(systemApp));
            }
            result.notImplemented();
        });
    }

    /// get application list systemApp : true,false.
    private List<Map<String, Serializable>> getInstalledList(boolean systemApp){
        List<Map<String, java.io.Serializable>> list = new ArrayList<>();
        final android.content.pm.PackageManager packageManager = contextWrapper.getPackageManager();
        List<PackageInfo> packages = packageManager.getInstalledPackages(0);
        for(int i=0; i<packages.size(); i++) {
            PackageInfo packageInfo = packages.get(i);
            if (systemApp){
                Map<String, Serializable> info = new HashMap<>();
                info.put("packageName", packageInfo.packageName);
                info.put("appName", packageInfo.applicationInfo.loadLabel(contextWrapper.getPackageManager()).toString());

                try {
                    info.put("appIcon", drawableToBase64String(packageManager.getApplicationIcon(packageInfo.packageName)));
                } catch (android.content.pm.PackageManager.NameNotFoundException e) {
                    e.printStackTrace();
                }

                list.add(info);
            }else {
                if ((packageInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) {
                    Map<String, Serializable> info = new HashMap<>();
                    info.put("packageName", packageInfo.packageName);
                    info.put("appName", packageInfo.applicationInfo.loadLabel(contextWrapper.getPackageManager()).toString());

                    try {
                        info.put("appIcon", drawableToBase64String(packageManager.getApplicationIcon(packageInfo.packageName)));
                    } catch (android.content.pm.PackageManager.NameNotFoundException e) {
                        e.printStackTrace();
                    }

                    list.add(info);
                }
            }
        }
        return list;
    }

    /// get bitmap style drawable
    private Bitmap drawableToBitmap(Drawable drawable) {
        Bitmap bitmap = null;

//        if (drawable is BitmapDrawable) {
//            if (drawable.bitmap != null) {
//                return drawable.bitmap;
//            }
//        }

        if (drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap will be created of 1x1 pixel
        } else {
            bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        }

        final Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    /// get base64 encoded string from drawable
    private String drawableToBase64String(Drawable drawable){
        Bitmap bitmap  = drawableToBitmap(drawable);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.WEBP, 100, baos);
        byte[] b = baos.toByteArray();
        return Base64.encodeToString(b, Base64.DEFAULT);
    }
}
