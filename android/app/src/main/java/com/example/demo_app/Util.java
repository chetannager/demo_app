package com.example.demo_app;

import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.XmlResourceParser;
import android.text.TextUtils;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.security.MessageDigest;
import java.text.DecimalFormat;
import java.util.Locale;
import org.xmlpull.v1.XmlPullParserException;

public class Util {
    public static String getAPKMD5(Context context, String apkSourceDir) {
        String md5 = "";
        if (TextUtils.isEmpty(apkSourceDir)) {
            return "";
        }
        try {
            md5 = getFileMD5String(new File(apkSourceDir));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return md5;
    }

    public static String getFileMD5String(File file) throws Exception {
        MessageDigest messagedigest = MessageDigest.getInstance("MD5");
        InputStream fis = new FileInputStream(file);
        byte[] buffer = new byte[1024];
        while (true) {
            int numRead = fis.read(buffer);
            if (numRead > 0) {
                messagedigest.update(buffer, 0, numRead);
            } else {
                fis.close();
                return byte2Hex(messagedigest.digest());
            }
        }
    }

    public static String byte2Hex(byte[] b) {
        if (b == null) {
            return null;
        }
        StringBuffer sBuffer = new StringBuffer();
        for (byte b2 : b) {
            String sTmep = Integer.toHexString(b2 & 255);
            if (sTmep.length() == 1) {
                sBuffer.append("0");
            }
            sBuffer.append(sTmep.toUpperCase(Locale.getDefault()));
        }
        return sBuffer.toString();
    }

    public static int getMinSdkVersion(File apkFile) throws ClassNotFoundException, IllegalAccessException, InstantiationException, NoSuchMethodException, InvocationTargetException, IOException, XmlPullParserException {
        AssetManager assetManager = (AssetManager) Class.forName("android.content.res.AssetManager").newInstance();
        XmlResourceParser parser = assetManager.openXmlResourceParser((Integer) assetManager.getClass().getMethod("addAssetPath", new Class[]{String.class}).invoke(assetManager, new Object[]{apkFile.getAbsolutePath()}), "AndroidManifest.xml");
        while (parser.next() != 1) {
            if (parser.getEventType() == 2 && parser.getName().equals("uses-sdk")) {
                for (int i = 0; i < parser.getAttributeCount(); i++) {
                    if (parser.getAttributeNameResource(i) == 16843276) {
                        return parser.getAttributeIntValue(i, -1);
                    }
                }
                continue;
            }
        }
        return -1;
    }
}
