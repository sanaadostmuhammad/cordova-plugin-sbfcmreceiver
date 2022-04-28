package cordova.plugin.customfcmreceiver;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.google.firebase.messaging.RemoteMessage;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.firebase.FirebasePluginMessageReceiver;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class CustomFCMReceiverPlugin extends CordovaPlugin {

    private static CallbackContext notificationCallbackContext;

    public static CustomFCMReceiverPlugin instance = null;
    static final String TAG = "CustomFCMReceiverPlugin";
    static final String javascriptNamespace = "cordova.plugin.customfcmreceiver";

    private CustomFCMReceiver customFCMReceiver;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        Log.d(TAG, "initialize");
        try {
            instance = this;
            this.webView = webView;
            customFCMReceiver = new CustomFCMReceiver();

        } catch (Exception e) {
            handleException("Initializing plugin", e);
        }
        super.initialize(cordova, webView);
    }

    protected static void handleError(String errorMsg) {
        Log.e(TAG, errorMsg);
    }

    protected static void handleException(String description, Exception exception) {
        handleError(description + ": " + exception.toString());
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("coolMethod")) {
            String message = args.getString(0);
            this.coolMethod(message, callbackContext);
            return true;
        } else if (action.equals("onMessageReceived")) {
            this.setMessageReceivedHandler(callbackContext);
            return true;
        }
        return false;
    }

    private void setMessageReceivedHandler(final CallbackContext callbackContext) {
        CustomFCMReceiverPlugin.notificationCallbackContext = callbackContext;
    }

    private void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void passSendbirdPaylod(JSONObject json, CallbackContext callbackContext) {
        if (json == null) {
            callbackContext.error("Couldn't parse payload");
        }
        try {
            // Parsing sendbird object. By default its received as string.
            JSONObject sendbirdJsonObj = new JSONObject(json.getString("sendbird"));
            json.put("sendbird", sendbirdJsonObj);
        } catch (JSONException e) {
            handleException("Parsing sendbird property", e);
        }

        PluginResult result = new PluginResult(PluginResult.Status.OK, json);
        result.setKeepCallback(true);
        callbackContext.sendPluginResult(result);
    }

    private JSONObject bundleToJSON(Bundle bundle) {
        JSONObject json = new JSONObject();
        Set<String> keys = bundle.keySet();
        for (String key : keys) {
            try {
                json.put(key, bundle.get(key));
            } catch (JSONException e) {
                handleException("Converting bundle to JSONObject", e);
                return null;
            }
        }
        return json;
    }

    private class CustomFCMReceiver extends FirebasePluginMessageReceiver {
        @Override
        public boolean onMessageReceived(RemoteMessage remoteMessage) {
            Log.d("CustomFCMReceiver", "onMessageReceived");
            boolean isHandled = false;

            try {
                if (remoteMessage.getData().containsKey("sendbird")) {
                    JSONObject bundleJson = new JSONObject(remoteMessage.getData());
                    instance.passSendbirdPaylod(bundleJson, CustomFCMReceiverPlugin.notificationCallbackContext);
                    isHandled = true;
                }
            } catch (Exception e) {
                handleException("onMessageReceived", e);
            }

            return isHandled;
        }

        @Override
        public boolean sendMessage(Bundle bundle) {
            Log.d("CustomFCMReceiver", "sendMessage");
            boolean isHandled = false;

            try {
                if (bundle != null && bundle.containsKey("sendbird")) {
                    JSONObject bundleJson = bundleToJSON(bundle);
                    instance.passSendbirdPaylod(bundleJson, CustomFCMReceiverPlugin.notificationCallbackContext);
                    isHandled = true;
                }
            } catch (Exception e) {
                handleException("onMessageReceived", e);
            }

            return isHandled;
        }
    }
}
