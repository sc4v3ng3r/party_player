package boaventura.com.br.party_player

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import com.ryanheise.audioservice.AudioServicePlugin

class MainApplication : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    @Override
    override fun onCreate() {
        super.onCreate()
        AudioServicePlugin.setPluginRegistrantCallback(this)
    }

    @Override
    override fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry)
    }
}