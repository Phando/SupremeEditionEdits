import CSI 1.0

Module {
    id: module
    property bool active: true
    property int deckId: 1
    property int width: 600
    property int height: 40

    StripeProvider { name: "stripe_provider"; channel: deckId; width: module.width; height: module.height }
    Wire { enabled: active; from: "surface.stripe_info"; to: "stripe_provider.output" }
    Wire { enabled: active; from: "stripe_provider.color"; to: ValuePropertyAdapter { path: "app.traktor.settings.waveform.color"; input: false } }

}
